require 'cinch'
require 'bashobot/nickserv'
require 'bashobot/bugzilla'
require 'bashobot/wiki'
require 'bashobot/pulls'
require 'bashobot/knowledgebase'
require 'bashobot/vimeo'
require 'yaml'

BashoBot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.plugins.plugins = [Nickserv, Bugzilla, Wiki, Pulls, KnowledgeBase, Vimeo]
    c.realname = "BashoBot :: https://github.com/basho/bashobot"
    if ENV['BASHOBOT'] == 'test'
      c.channels = []
      c.nick = "test_bashobot"
      c.plugins.plugins.delete Nickserv
    else
      c.channels = %w{#riak}
      c.nick = "bashobot"
    end
  end
  self.logger = Cinch::Logger::FormattedLogger.new(File.open(File.expand_path("../../log/bashobot.log", __FILE__), "a")) unless ENV['BASHOBOT'] == 'test'
end
