require 'cinch'
require 'bashobot/nickserv'
require 'bashobot/bugzilla'
require 'bashobot/wiki'
require 'bashobot/pulls'
require 'bashobot/knowledgebase'
require 'yaml'

BashoBot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = %w{#riak}
    c.nick = "bashobot"
    c.realname = "BashoBot :: https://github.com/basho/bashobot"
    c.plugins.plugins = [Nickserv, Bugzilla, Wiki, Pulls, KnowledgeBase]
  end
  self.logger = Cinch::Logger::FormattedLogger.new(File.open(File.expand_path("../../log/bashobot.log", __FILE__), "a"))
end
