# frozen_string_literal: true

class HealthzController < ApplicationController
  post '/release_trains' do
    params = JSON.parse(request.body.read)
    'ok'
  end
end
