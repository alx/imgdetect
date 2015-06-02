# encoding: UTF-8
class Prediction
  include DataMapper::Resource

  property :id,     Serial
  property :prob,   Float

  belongs_to :image
  belongs_to :category
end
