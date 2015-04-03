require 'net/http'

class ImageController < ApplicationController
  def list
    # http = Net::HTTP.new("http://localhost", 3000)
    # request = Net::HTTP::Post.new("http://localhost:3000")
    # request.set_form_data({"user[name]" => "testusername", "user[email]" => "testemail@yahoo.com"})

    # @response = http.request(request)
    # render :json => response.body

    # uri = URI('http://localhost:3000/image/list')
    # datas = Net::HTTP.get(URI('http://localhost:3000/image/list'))
    # @datas = ActiveSupport::JSON.decode(datas)
  end
end
