# frozen_string_literal: true

class Crowdtanglego < ApplicationRecord
  def self.count_result(params)
    begin
      uri = URI("https://f586d68900d0.ngrok.io/posts")
      request = JSON.parse(Net::HTTP.get_response(uri).body)

      request 
    rescue => e  
      e
    end
  end
end
