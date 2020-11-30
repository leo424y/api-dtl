# frozen_string_literal: true

class Twint < ApplicationRecord
  def self.count_result(params)
    p = URI.encode_www_form(q: params[:q])
    uri = URI("https://#{ENV['CTCSVHOST']}/tweets?#{p}")
    result = Timeout.timeout(60) {
      JSON.parse(Net::HTTP.get_response(uri).body)
    }
    {
      status: 'ok',
      params: params,
      count: result.count || 0,
      result: result
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
