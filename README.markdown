This is Joel Grus idea (and code!) of classifying Hacker News posts taken (too?) further. 
I really like the idea of a complete database of Hacker News posts, completely sorted
to my liking and which I can use right from the command line. So I decided to make it further 
better to wrok on the command line. 

INSTALLATION
=============

To install the gem, first clone the project using 

	$ git clone git://github.com/webholik/hackernews.git

Change the directory:

	$ cd hackernews

I am at the moment working on the test branch so first check it out using:
	
	$ git checkout test

Now build the gem with:

	$ gem build hackernews.gemspec

And finally install with:

	$ gem install hackernews-0.0.1.gem


USAGE
=====

Firstly you will need to add some stories to your collection with:

	$ hacker collect

Then start judging a few stories, to train the program:

	$ hacker judge

Then the program will ask you whether you like the story or not and record your judgement and 
it will use that data to judge other stories in the database for you

	hnid: 1859249
	title: Good YC Applications, More Interviews
	domain: twitter.com
	url: http://twitter.com/paulg/status/29438424751
	user: 
	
	prediction: 0.17693878988518696
	good? >> 

You can simply press `y` if you like it or `n` if you not. You can also type `read` to read the story right
in the terminal. The script will fetch the page and try to get the useful text out of that page. It won't work on
everything though. For example, if the link was to a PDF file, then the conversion will fail, or if the link was to a forum
then it will fail. Also you can't see images inside the terminal. But for a lot of cases, reading in the terminal will work.
To classify the database based on the judgement you have made, type `classify` or simply `c`, and the script will classify the 
whole database and throw out some stats.For more commands type `help`.

For quiting without classifying, simple type `quit`.

To view the top 10 stories that have been judged for you type:

	$ hacker top 10

To get new stories for your database type:

	$ hacker new


TODO
====

-  Fetching the text out of a page fails where it shouldn't. Work on that
-  Classification completely ignores the content of a page, work out a new algorithm
	for the classification
-  Get a name for the gem
