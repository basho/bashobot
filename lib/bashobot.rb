require 'cinch'
require 'bashobot/bugzilla'
require 'bashobot/wiki'
require 'yaml'

BashoBot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.net"
    c.channels = %w{#riak}
    c.nick = "bashobot"
    c.realname = "BashoBot :: https://github.com/basho/bashobot"
    c.password = YAML.load_file(File.expand_path("../../auth.yml", __FILE__))['password']
    c.plugins.plugins = [Bugzilla, Wiki]
  end
end
