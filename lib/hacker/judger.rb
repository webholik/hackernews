# manually score stories as like or dislike, for use in building the model
# "ruby judger.rb" to see unjudged stories 
# "ruby judger.rb word" to see all stories with "word" in their title

require_relative "story"
require_relative "model"
require_relative "utils"

# unjudged stories, sorted by hnid descending

def judger(*argv)
	# if we gave it args, use the first to match with
	total = Story.count
	if argv.size > 0
		term = argv.first
		re = Regexp.new(term,true)
		stories = Story.where(:link_title => re).to_a.shuffle

		puts "#{stories.count} stories containing #{term}"
	else

		stories = Story.where(:like => nil).to_a.shuffle #sort(:hnid.desc)
		unjudged_count = stories.count

		puts "#{total} stories in database"
		puts "#{total - unjudged_count} judged"
		puts "#{unjudged_count} left to judge"
		puts
	end


	stories.each do |s|
		puts "hnid: #{s.hnid}"
		puts "title: #{s.link_title}"
		puts "domain: #{s.domain}"
		puts "url: #{s.link_url}"
		puts "user: #{s.user}"
		puts
		puts "previous judgment: #{s.like}" if s.like
		puts "prediction: #{s.prediction}" if s.prediction
		print "good? >> "
		answer = STDIN.gets
		if /^y/i =~ answer
			puts "you liked it!"
			s.like = true
		elsif /^n/i =~ answer
			puts "you didn't like it!"
			s.like = false
		#sometimes I just want to ignore the current item and decide what 
		#to do about it later
		elsif /^i/i =~ answer   
			puts
			next

		elsif /^q/i =~ answer
			return

		# Classify the database
		elsif /^c/i =~ answer
			break
			
		#Sometimes, press Enter hard enough and it gets pressed twice
		else
			puts
			puts "Sorry, didn't understand"
			puts "Use q(quit), i(ignore), c(classify), y(yes), n(no)"
			sleep(0.7)	#Else, we won't see the usage message
			puts
			redo
		end

		s.save
		puts
	end

	puts "retraining model"
	# after judging, retrain the model  
	model = Model.new
	model.train(2)
	model.save

	# and reclassify everything

	require_relative "back_predict"
	back_predict(false,false)

	require_relative "test_featurizer"  
end
