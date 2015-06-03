require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-migrations'
require 'rest-client'
require 'nokogiri'
require 'open-uri'

configure :development do
  enable :cross_origin
  set :dd_host, "swyn.fr"
  set :dd_port, "8081"
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(
    :default,
    'mysql://root@localhost/imgdetect'
  )
  #DataMapper::Model.raise_on_save_failure = true
end

configure :production do
  enable :cross_origin
  DataMapper.setup(
    :default,
    'mysql://root@localhost/imgdetect'
  )
end

require './models/init'

DataMapper.finalize

doc = Nokogiri::HTML(open("http://imgur.com/topic/Aww/time"))
doc.css('div.post').each do |post|
  url = "http://i.imgur.com/#{post['id']}.jpg"
  p url
  begin
    open(url, "r") do |file|
      Image.first_or_create(:url => url)
    end
  rescue => e
    p "unabel to fetch #{url} : #{e}"
  end
end
