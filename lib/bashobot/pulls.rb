require 'cinch'
require 'bashobot/github'

class Pulls
  include Cinch::Plugin

  plugin "pullrequests"
  react_on :message

  prefix ''
  suffix ''

  match /\!help/i, method: :help, use_prefix: false

  match /!pull\s+([-\w]+)\s*(.*)/i, method: :find_pull

  def help(message)
    message.reply "[HELP] !pull <repository> <terms?> : Find pull-requests on a basho repository"
  end

  def find_pull(message, repository, terms)
    sterms = terms.strip.scan(/\S+/)
    pulls = Github.pulls(repository)['pulls'] rescue []
    unless sterms.empty?
      sterms = sterms.map {|t| Regexp.new(Regexp.quote(t)) }
      pulls.select! {|p| sterms.all? {|t| p['title'] =~ t } }
    end
    message.reply "No pull-requests found in #{repository} with terms '#{terms}'." if pulls.empty?
    pulls.each do |p|
      message.reply "[PR] #{p['title']} #{p['html_url']}"
    end
  end
end
