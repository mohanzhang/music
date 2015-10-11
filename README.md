Hi! This is the code for the lyrics subsite that you'll find at
[www.mohanzhang.com/music](http://www.mohanzhang.com/music). It's compiled by hakyll, and relies on
ruby's bundler to install haml and sass on the commandline.

## Installation

There is a `.ruby-version` file provided to set the ruby version. Make sure bundler is installed,
then `bundle install` to get haml and sass on the commandline.

Hakyll itself is installed with `stack`. Do `stack install` to put the `site` executable on your
path. This then lets you run `stack exec ./preview` to start the executable watching your source
files. The site will then be available on http://localhost:8000.

## Background

I've released two albums so far, both self-produced. The first one, *The Every Mile Made Yours EP*,
was released in December of 2013 and was the product of a self-imposed 60-day limit. As you can
imagine, for a first-time effort given only 60 days, the result was merely... ok.

Half a year after I released my first EP, I set out to do a self-produced album that I could be more
satisfied with, and so I started writing for *Western Hearts Pacific Skies EP*. I originally
budgeted four months to get it done (twice as long as the first one), but getting a good enough
result that I could be happy with actually took over 15 months. Work and life obviously affected
that timeline since my original 60 days were unemployed and worry-free living at home.

You can read more about the first EP on [my blog](https://mohanzhang.wordpress.com/2013/12/14/from-zero-to-ep-in-60-days-part-1-inception/).
I'll eventually write about the making of the second EP as well.
