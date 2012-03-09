#ARGV.each_with_index do |arg, num|
	#if arg == 'judge'
		#require_relative 'hacker/judger'
		#if ARGV[num+1] then judger(ARGV[num+1])
		#else judger()
		#end
#
	#elsif arg == 'scrape'
		#require_relative 'hacker/scrape_api'
		#pages = ARGV[num+1] ? ARGV[num+1].to_i : 10
		#scrape(pages, "https://api.ihackernews.com/new")
#
	#elsif arg == 'view'
		#require_relative 'hacker/viewer'
		#num_items = ARGV[num+1] ? ARGV[num+1].to_i : 10
		#view(num_items)
#
	#else
		#puts "Unrecogonized option : #{arg}"
	#end
	#break;
#end

case ARGV[0]
when 'judge'
	require_relative 'hacker/judger'
	if ARGV[1] then judger(ARGV[1]) else judger() end

when 'scrape'
	require_relative 'hacker/scrape_api'
	scrape(ARGV[1] ? ARGV[1].to_i : 10,
		   "http://api.ihackernews.com/new")

when 'view'
	require_relative 'hacker/viewer'
	view(ARGV[1] ? ARGV[1].to_i : 10)

else
	puts "Usage : "
	puts "hacker judge|scrape|view"
end
