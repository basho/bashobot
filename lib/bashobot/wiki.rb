require 'cinch'
require 'mechanize'
require 'uri'

class Wiki
  include Cinch::Plugin
  prefix '!wiki'
  suffix ''
  react_on :message

  match /\!help/i, method: :help, use_prefix: false
  match /\s*(.*)/i, method: :find_wiki_page

  timer 86400, method: :refresh_wiki

  def help(message)
    message.reply "[HELP] !wiki <terms> : Finds wiki pages that have terms in the title"
  end
  
  def wiki
    synchronize(:wiki) do
      @wiki ||= fetch_wiki
    end
  end
  
  def find_wiki_page(message, match)
    words = match.split(/\W+/).map {|w| Regexp.new(w.downcase, Regexp::IGNORECASE) }
    (wiki / "#sidebar" / "a").each do |link|
      if words.any? {|w| link.inner_html =~ w }
        message.reply "[Riak wiki] #{URI.join('http://wiki.basho.com', link['href'])}"
      end
    end
  end

  def refresh_wiki
    synchronize(:wiki) do
      @wiki = fetch_wiki
    end
  end

  def fetch_wiki
    Mechanize.new.get("http://wiki.basho.com/")
  end
end
