# frozen_string_literal: true

class Youtube < ApplicationRecord
  def self.count_result(params)
    p = URI.encode_www_form(q: params[:q])
    uri = URI("https://ed30cab9967d.ngrok.io/youtubes?#{p}")
    result = Timeout.timeout(50) { 
      JSON.parse(Net::HTTP.get_response(uri).body)
    } 

    {
      status: 'ok',
      params: params,
      count: result ? result.count : 0,
      result: result
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
