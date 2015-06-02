# encoding: UTF-8
require_relative './images'

get '/' do
  images = Image.all(:limit => 10, :order => [:created_at.desc])
  erb :index, :locals => {:list => images}
end
