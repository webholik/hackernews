require 'rake'
Gem::Specification.new do |s|
	s.name = 'hackernews'
	s.version = '0.0.1'
	s.date =    '2012-03-08'
	s.email = 'ankit28595@gmail.com'
	s.summary = 'Explore hacker news'
	s.authors = ['Ankit Saini']
	s.files = FileList['lib/**/*.rb',
						'lib/*.rb',
						'lib/**/model.mod',
						'bin/hacker']
	s.executables << 'hacker'
	s.description = <<-EOF
	The gem includes a Naive Bayes Classifier to classify
	Hacker News post to filter out the ones that you are most likely
	to love. 
	EOF
	s.homepage = 'http://github.com/webholik/hackernews'
end
