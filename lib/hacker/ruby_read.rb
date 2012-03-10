# Get the article out of a webpage 
# Complete credit to http://code.google.com/p/arc90labs-readability/

require 'open-uri'
require 'nokogiri'
require 'set'

class Parser
	def initialize(url=nil)
		if url
			@document = Nokogiri::HTML(open(url))
			@top_div = nil
			@links = Set.new()
			pattern = %r{<br/?>[ \r\n\s]*<br/?>}
			@document.inner_html = @document.inner_html.gsub(pattern, "</p><p>").gsub(/<\/?font[^>]*>/, '')
			title = @document.title
			parents = Set.new
			paragraphs = @document.css('p')
			#paragraphs << @document.css('blockquote')
			#paragraphs.flatten!.compact!

			paragraphs.each do |para|
				parent = para.parent

				if (parent['read_score'] == nil)
					parent['read_score'] = '0' # Adding a number as an HTML attribute doesn't work
					parents.add parent
				end

				if parent['class'] && parent['class'].match(/(comment|meta|footer|footnote)/) 
					parent['read_score'] = (parent['read_score'].to_i - 50).to_s

				elsif parent['class'] && parent['class'].match(/(post|hentry|entry[-]?
																 (content|text|body)?|article[-]?
																 (content|text|body)?)/x)
					parent['read_score'] = (parent['read_score'].to_i + 25).to_s
				end

				if parent['id'] && parent['id'].match(/(comment|meta|footer|footnote)/)
					parent['read_score'] = (parent['read_score'].to_i - 50).to_s

				elsif parent['id'] && 
					parent['id'].match(/(post|hentry|entry[-]?(content|text|body)?|
										 article[-]?(content|text|body)?)/x)
					parent['read_score'] = (parent['read_score'].to_i + 25).to_s
				end

				if parent.name == 'article'
					parent['read_score'] = (parent['read_score'].to_i + 50).to_s
				end

				if para.inner_text.length > 10 
					parent['read_score'] = (parent['read_score'].to_i + 1).to_s
				end

			end
			parents.each do |parent|
				if @top_div
					if parent['read_score'] > @top_div['read_score']
						@top_div = parent
					end
				else
					@top_div = parent
				end
			end

			return nil if not @top_div

			clean(@top_div, "form")
			clean(@top_div, "object")
			clean(@top_div, "iframe")
			clean(@top_div, "script")

			normalize(@top_div)

			title_elem = Nokogiri::XML::Node.new("h1", @document)
			title_elem.content = title

			@html = '<html> <body> </body> </html>'

			@html = Nokogiri::HTML(@html)
			@body = @html.at_css('body')
			@body.add_child(title_elem)
			@body.add_child(@top_div)
		end
	end


	def clean(elem, tag)
		targets = elem.css(tag)
		targets.each do |tag|
			tag.remove()
		end
	end

	def normalize(elem)
		elem.attributes.keys.each do |attr|
			next if attr == 'href' or attr == 'src'
			elem.remove_attribute(attr)
		end

		if elem.children.length > 0 
			elem.children.each do |child|
				normalize(child)
			end
		end
	end
	def handle_ol(elem, text)
		elem.children.each_with_index do |child, i|
			if child.name == 'li'
				text << "#{i+1}.)  " << child.inner_text << "\n"
				text = formatted_plain_text(child, text)
			else
				text = formatted_plain_text(child, text)
			end
		end

		return text
	end

	def handle_links(html, link_set)
		html.css('a').each do |elem|
			link_set.add(elem['href']) 
			elem.content = elem.content << "(#{link_set.length}) "
		end
	end


	def formatted_plain_text(elem, text = '')
		handle_children = Proc.new do |papa|
			if papa.children then
				papa.children.each do |child|
					formatted_plain_text(child, text)
				end
			end
		end
		case elem.name
		when 'p'
			text << "\n" << elem.inner_text << "\n"
			handle_children.call(elem)

		when 'img'
			text << "\n" << "[IMAGE]" << "\n"

		when 'h1'
			text << "\n" << elem.inner_text << "\n" \
				<< "=" * elem.inner_text.length << "\n"
			handle_children.call(elem)

		when 'h2'
			text << "\n" << "## " << elem.inner_text << "\n"
			handle_children.call(elem)

		when 'h3'
			text << "\n" << "### " << elem.inner_text << "\n"
			handle_children.call(elem)

		when 'a'
			#Links are already handled

		when 'ul'
			text << "\n"
			handle_children.call(elem)

		when 'ol'
			text << "\n"
			text = handle_ol(elem, text)

		when 'li'
			text << "-  " << elem.inner_text << "\n"
			handle_children.call(elem)

		when 'blockquote'
			elem.content = elem.content.gsub("\n", "\n>  ")
			handle_children.call(elem)

		else
			handle_children.call(elem)
		end

		return text
	end

	def insert_links(text, link_set)
		text << "\n" << "Links refrenced in the above article: \n\n"
		link_set.each_with_index do |link, index|
			text << "(#{index+1})  -  " << link << "\n" 
		end
		return text
	end

	def internal_formatted_text(elem)
		links = Set.new		# keep a track of each link in the story
		handle_links(elem, links)
		text = formatted_plain_text(elem)
		text = insert_links(text, links)
		return text
	end

	def formatted_text
		# We are going to change the page's content to get a better
		#	output for reading in terminal, so keep the original content
		#	safe.
		body = @body.dup
		text = internal_formatted_text(body)
		return text
	end

	def raw_html
		return @document.to_html
	end

	def parsed_html
		return @html.to_html
	end

	def Parser.generate_text(html)
		html = Nokogiri::HTML(html)
		obj = Parser.new()
		text = obj.send(:internal_formatted_text, html)
		return text
	end

	def Parser.get(url)
		open(url).read
	end



end


