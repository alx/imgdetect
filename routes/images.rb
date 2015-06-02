# encoding: UTF-8

get '/api/imges' do
  format_response(Image.all, request.accept)
end

get '/api/images/:id' do
  image ||= Image.get(params[:id]) || halt(404)
  format_response(image, request.accept)
end

post '/api/images' do
  image = Image.first_or_create(
    url: params['url']
  )
  status 201
  format_response(image, request.accept)
end

put '/api/images/:id' do
  body = JSON.parse request.body.read
  image ||= Image.get(params[:id]) || halt(404)
  halt 500 unless image.update(
    url: body['url'],
  )
  format_response(image, request.accept)
end

delete '/api/images/:id' do
  image ||= Image.get(params[:id]) || halt(404)
  halt 500 unless image.destroy
end

options '/api/images' do
  '*'
end
