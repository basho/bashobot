require 'cinch'
require 'mechanize'
require 'uri'

class Bugzilla
  include Cinch::Plugin

  plugin "bugzilla"
  react_on :message

  prefix ''
  suffix ''

  match /\!help/i, method: :help, use_prefix: false
  
  match /\!bug\s+(\d+)/i, :method => :lookup_bug
  match /bz:(?:\/\/)?(\d+)/i, :method => :lookup_bug
  match /\!bugsearch\s+(.*)/i, :method => :search_bugs

  def help(message)
    message.reply "[HELP] !bug <bug id> : Look up a bug on issues.basho.com"
    message.reply "[HELP] bz://<bug id> : Look up a bug on issues.basho.com"
    message.reply "[HELP] !bugsearch <terms> : Do a search for bugs on issues.basho.com"
  end
  
  def bugzilla
    @bugzilla ||= Mechanize.new
  end

  def lookup_bug(message, issue)
    url = "https://issues.basho.com/show_bug.cgi?id=#{issue}"
    page = synchronize(:bz) do
      bugzilla.get url
    end
    title = page.title.encode('ASCII', replace:' ').sub(/Bug (\d+)\s+/, '[\1] ')
    message.reply "#{title} - #{url}"
  end

  def search_bugs(message, query)
    query = URI.escape(query)
    url = "https://issues.basho.com/buglist.cgi?quicksearch=#{query}"
    page = synchronize(:bz) do
      bugzilla.get url
    end
    unless (page.root / "span.zero_results").empty?
      message.reply "No bugs found for '#{query}'."
      return
    end
    table = page.root / "table.bz_buglist"
    table.children.each do |row|
      if row['class'] =~ /bz_bugitem/
        link = (row / 'a').first
        bug_uri = URI.join(url, link['href'])
        bug_id = link.inner_html.strip
        summary = (row / 'td.bz_short_desc_column').first.inner_html.strip
        message.reply "[#{bug_id}] #{summary.encode('ASCII', replace:'')} - #{bug_uri.to_s}"
      end
    end
  end
end
