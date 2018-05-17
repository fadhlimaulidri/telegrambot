# frozen_string_literal: true
class ReleaseTrainsController < ApplicationController
  post '/' do
    path = 'http://172.16.8.89:8080/view/smoke-testing-squad/api/json'
    resp = HTTParty.get(path).body
    response = JSON.parse(resp)['jobs']
    values = {}
    response.each do |job|
      if !AssigneeSquad['exclude'].include?(job['name'])
        values[job['name'].to_sym] = {
          usernames: AssigneeSquad['squads'][job['name']],
          status: job_status(job['color'])
        }
      end
    end

    RedisServer.set('smoke_test_duty', values.to_json)
    'ok'
  end

  private

  def job_status(status)
    return true if status == 'blue'
    false
  end
end
