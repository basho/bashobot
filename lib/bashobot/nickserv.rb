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
    User('NickServ').notice("identify #{password}")
  end
end
