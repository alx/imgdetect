# encoding: UTF-8
class Category
  include DataMapper::Resource

  property :id,     Serial
  property :nid,    String
  property :name,   Text

  has n, :predictions
end
