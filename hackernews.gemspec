require 'rake'
Gem::Specification.new do |s|
	s.name = 'hackernews'
	s.version = '0.0.1'
	s.date =    '2012-03-08'
	s.summary = 'Explore hacker news'
	s.authors = ['Ankit Saini']
	s.files = FileList['lib/**/*.rb',
						'lib/*.rb',
						'lib/**/model.mod',
						'bin/hackernews']
	s.executables << 'hackernews'
end
