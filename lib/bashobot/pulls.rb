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
    terms = terms.split(/\s*/)
    pulls = Github.pulls(repository)['pulls'] rescue []
    unless terms.empty?
      pulls.select! {|p| terms.any? {|t| p['title'] =~ Regexp.new(Regexp.quote(t)) } }
    end
    pulls.each do |p|
      message.reply "[PR] #{p['title']} #{p['html_url']}"
    end
  end
end
