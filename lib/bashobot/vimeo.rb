require 'cinch'
# require 'nokogiri'
require 'net/http'
require 'json'

class Vimeo
  include Cinch::Plugin
  plugin "vimeo"

  react_on :message
  # prefix "!"
  
  match /\!help/i, method: :help, use_prefix: false
  match /(?:video|vimeo|webinar)\s*(.*)$/i

  timer 86400, method: :refresh_vimeo

  def vimeo
    synchronize(:vimeo) do
      @vimeo ||= fetch_vimeo
    end
  end
  
  def help(message)
    message.reply "[HELP] !vimeo <terms> : Search Basho's videos (also !video and !webinar)"
  end

  def execute(message, terms)
    words = terms.split(/\W+/).map {|w| Regexp.new(w.downcase, Regexp::IGNORECASE) }
    replies = 0
    vimeo.each do |video|
      fields = video['title'] + video['description'] + video['tags']
      if words.any? {|w| fields =~ w }
        replies += 1
        message.reply "[Vimeo] #{video['title']} #{video['url']}"
      end
    end
    message.reply "[Vimeo] No videos found matching '#{terms}'." unless replies > 0
  end

  def refresh_vimeo
    synchronize(:vimeo) do
      @vimeo = fetch_vimeo      
    end
  end

  def fetch_vimeo
    JSON.parse Net::HTTP.get(URI.parse("http://vimeo.com/api/v2/bashotech/videos.json"))
  end
end
