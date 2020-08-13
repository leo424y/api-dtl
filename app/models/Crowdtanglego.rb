# frozen_string_literal: true

class Crowdtanglego < ApplicationRecord
  def self.count_result(params)
    begin
      p = URI.encode_www_form(q: params[:q], start_date: params[:start_date], end_date: params[:end_date])
      uri = URI("https://f586d68900d0.ngrok.io/posts?#{p}")
      request = JSON.parse(Net::HTTP.get_response(uri).body)

      {result: request}
    rescue => e  
      e
    end
  end
end
