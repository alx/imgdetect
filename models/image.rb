# encoding: UTF-8
class Image
  include DataMapper::Resource

  property :id,         Serial
  property :url,        Text
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :predictions

  before :save, :predict

  def to_json
    json = {:url => self.url, :predictions => []}
    self.predictions.each do |prediction|
      json[:predictions] << {
        prob: prediction.prob,
        name: prediction.category.name,
        nid:  prediction.category.nid
      }
    end
    json.to_json
  end

  def predict

    predict_url =   "http://#{Sinatra::Application.settings.dd_host}"
    predict_url +=  ":#{Sinatra::Application.settings.dd_port}/predict"

    p predict_url

    RestClient.post(
      predict_url,
      {
        :service => "imageserv",
        :parameters => {
          :input  => {:width => 224, :height => 224},
          :output => {:best => 3}
        },
        :data => [self.url]
      }.to_json
    ) do |response, request, result|

      case response.code
      when 200
        body =  JSON.parse(response.body)
        predictions = body['body']['predictions']['classes']
        predictions.each do |prediction|

          re = /(n\d+) (.*)/
          md = re.match(prediction['cat'])

          category = Category.first_or_create(
            nid: md[1],
            name: md[2]
          )

          self.predictions << Prediction.create(
            prob: prediction['prob'],
            category: category
          )
        end
      end

    end

    if self.predictions.size == 0
      throw :halt
    end

  end
end
