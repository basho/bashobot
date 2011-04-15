require 'cinch'
require 'yaml'

class Nickserv
  include Cinch::Plugin

  react_on :private
  prefix ''
  suffix ''

  match /This nickname is registered/

  def password
    @password ||= YAML.load_file(File.expand_path("../../../auth.yml", __FILE__))['password']
  end

  def execute(*args)
    User('NickServ').msg("identify #{password}")
  end

  timer 300, method: :claim_nick

  def claim_nick
    if bot.nick != 'bashobot'
      User('NickServ').msg("ghost bashobot #{password}") unless User('bashobot').unknown?
      bot.nick = 'bashobot'
    end
  end
end
