# frozen_string_literal: true

class Wikipedia < ApplicationRecord
  def self.count_result(params)
    api_uri = URI "https://zh.wikipedia.org/w/api.php?action=query&list=search&srsearch=#{URI.escape params[:q]}&utf8&format=json"
    response = Timeout.timeout(30) { Net::HTTP.get_response(api_uri) }
    result = JSON.parse(response.body)['query']['search']
    count = result ? result.count : 0
    {
      status: 'ok',
      params: params,
      count: count,
      result: result,
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
