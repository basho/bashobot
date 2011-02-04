require 'cinch'
require 'bashobot/nickserv'
require 'bashobot/bugzilla'
require 'bashobot/wiki'
require 'bashobot/pulls'
require 'yaml'

BashoBot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = %w{#riak}
    c.nick = "bashobot"
    c.realname = "BashoBot :: https://github.com/basho/bashobot"
    c.plugins.plugins = [Nickserv, Bugzilla, Wiki, Pulls]
  end
end
