require 'httparty'

module Github
  extend self
  USER = "basho"

  include HTTParty
  base_uri "https://github.com/api/v2/json"
  format :json

  def pulls(repository, state="open")
    get("/pulls/#{USER}/#{repository}/#{state}")
  end
end
