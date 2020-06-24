# frozen_string_literal: true

class Claim < ApplicationRecord
  def self.count_result(params)
    claim_uri = URI "https://factchecktools.googleapis.com/v1alpha1/claims:search?key=#{ENV['CLAIM_KEY']}&languageCode=zh&query=#{URI.escape params[:q]}&pageSize=10000"
    response = Timeout.timeout(30) { Net::HTTP.get_response(claim_uri) }
    claims = JSON.parse(response.body)['claims']
    count = claims.count
    result = {
      status: 'ok',
      params: params,
      count: count,
      result: claims,
    }
    result
  rescue StandardError => e
    {
      status: e
    }
  end
end
