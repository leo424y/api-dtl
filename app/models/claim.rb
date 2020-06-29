# frozen_string_literal: true

class Claim < ApplicationRecord
  def self.count_result(params)
    claim_uri = URI "https://factchecktools.googleapis.com/v1alpha1/claims:search?key=#{ENV['CLAIM_KEY']}&languageCode=zh&query=#{URI.escape params[:q]}&pageSize=10000"
    response = Timeout.timeout(30) { Net::HTTP.get_response(claim_uri) }
    result = JSON.parse(response.body)['claims']
    count = result ? result.count : 0 
    {
      status: 'ok',
      params: params,
      count: count,
      result: result ? result.sort_by { |h| h['claimReview'][0]['reviewDate'] } : [],
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
