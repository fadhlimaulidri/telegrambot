# frozen_string_literal: true

class ReleaseTrainsController < ApplicationController
  post '/' do
    params = JSON.parse(request.body.read)
    'ok'
  end
end
