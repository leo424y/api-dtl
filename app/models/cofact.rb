# frozen_string_literal: true

class Cofact < ApplicationRecord
  def self.count_result(params)
    result = (Rumors::Api::Client.search params[:q])
    api_result(params, result, 'cofacts')
  rescue StandardError => e
    {
      status: e
    }
  end
end
