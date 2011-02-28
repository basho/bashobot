require 'cinch'
require 'mechanize'
require 'uri'

class KnowledgeBase  
  include Cinch::Plugin

  plugin "knowledgebase"

  react_on :message
  prefix "!kb"
  suffix ""

  match /\!help/i, method: :help, use_prefix: false
  match /\s*(.*)$/i

  KB_URL = "https://help.basho.com/categories/search/5259-knowledge-base"

  def help(message)
    message.reply "[HELP] !kb <terms> : Search the Knowledge Base on help.basho.com"
  end

  def execute(message, terms)
    terms = terms.strip.scan(/\S+/).join(" ")
    url = "#{KB_URL}?query=#{URI.escape(terms)}"
    page = synchronize(:kb) do
      kb.get url
    end
    if !(page.root / "h3.empty_result_set").empty?
      message.reply "No Knowledge Base articles found for '#{terms}'"
      return
    else
      page.root.css(".item-info h1 a").each do |link|
        linkuri = URI.join(KB_URL, link.attribute('href').content)
        message.reply "[KB] #{encode(link.text)} #{encode(linkuri)}"
      end
    end
  end

  def kb
    @kb ||= Mechanize.new
  end

  def encode(string)
    string.encode('ASCII', replace: ' ')
  end
end
