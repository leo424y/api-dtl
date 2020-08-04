# frozen_string_literal: true

class Youtube < ApplicationRecord
  def self.count_result(params)
    result = Timeout.timeout(30) { 
      JSON.parse(%x(youtube-dl --default-search "ytsearch999:" --skip-download -J #{params[:q]}))['entries'].sort_by { |h| h['upload_date'] }
    }    
    count = result ? result.count : 0 
    {
      status: 'ok',
      params: params,
      count: count,
      result: result
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
