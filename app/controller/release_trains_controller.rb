# frozen_string_literal: true

class ReleaseTrainsController < ApplicationController
  post '/' do
    # params = JSON.parse(request.body.read)
    # 'ok'
  path = 'http://172.16.8.89:8080/view/vp-prepaid/api/json'
  resp = HTTParty.get(path).body
  response = JSON.parse(resp)['jobs']
  
  # response.each do |value|
  #   puts value['name']
  # end
# puts response


  response.each do |key, array|
  
  # input to redis
  puts "#{key}-----"
  end

  end
end
