ARGV.each_with_index do |arg, num|
	if arg == 'judge'
		require_relative 'hacker/judger'
		if ARGV[num+1] then judger(ARGV[num+1])
		else judger()
		end

	elsif arg == 'scrape'
		require_relative 'hacker/scrape_api'
		pages = ARGV[num+1] ? ARGV[num+1].to_i : 10
		scrape(pages, "https://api.ihackernews.com/new")

	elsif arg == 'view'
		require_relative 'hacker/viewer'
		num_items = ARGV[num+1] ? ARGV[num+1].to_i : 10
		view(num_items)

	else
		puts "Unrecogonized option : #{arg}"
	end
	break;
end
