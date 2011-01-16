require 'cinch'
require 'bashobot/bugzilla'
require 'bashobot/wiki'

BashoBot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = %w{#riak}
    c.nick = "bashobot"
    c.plugins.plugins = [Bugzilla, Wiki]
  end
end
