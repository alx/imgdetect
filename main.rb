# encoding: UTF-8
require 'json'
require 'sinatra'
require 'data_mapper'
require 'dm-migrations'
require 'sinatra/cross_origin'
require 'sinatra/partial'
require 'rest-client'

set :public_folder, File.dirname(__FILE__) + '/public'
set :server, 'thin'
set :partial_template_engine, :erb

configure :development do
  enable :cross_origin

  set :dd_host, "swyn.fr"
  set :dd_port, "8081"

  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(
    :default,
    'mysql://root@localhost/imgdetect'
  )
end

configure :production do
  enable :cross_origin

  set :dd_host, "localhost"
  set :dd_port, "8081"

  DataMapper.setup(
    :default,
    'mysql://root@localhost/imgdetect'
  )
end

require './models/init'
require './helpers/init'
require './routes/init'

DataMapper.finalize
