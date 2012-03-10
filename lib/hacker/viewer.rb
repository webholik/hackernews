#  A simple script to show the top 10 links in the database

require 'mongo'
#num = ARGV[0] ? ARGV[0].to_i : 10

# Commented because runs in 3.276s (ten times slower than directly using Mongo)
#require_relative 'story'
#Story.all().sort{|a,b| a.prediction <=> b.prediction}.last(10).each do |i|
#	output.puts i.link_title
#	output.puts i.link_url
#	output.puts i.prediction
#	output.puts
#end 

#Runs in 0.3 seconds
def view(num)
	top_stories = []
	Mongo::Connection.new().db("hackernews").collection('stories').find().each do |story|
		if story['prediction'] > 0.5
			top_stories.push(story)
		end
	end
	top_stories.sort! do |s1, s2|
		s1['prediction'] <=> s2['prediction']
	end

	output = IO.popen("less", "w")

	output.puts "Top #{num} stories are:"
	output.puts
	top_stories.last(num).reverse.each do |story|
		output.puts story['link_title']
		output.puts story['link_url']
		output.puts story['prediction']
		output.puts
	end

	#less_print(output)
	output.close
end
