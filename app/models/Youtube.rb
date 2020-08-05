# frozen_string_literal: true

class Youtube < ApplicationRecord
  def self.count_result(params)
    result = Timeout.timeout(30) { 
      JSON.parse(%x(youtube-dl --default-search "ytsearch999:" --skip-download -J #{params[:q]}))
    } 

    {
      status: 'ok',
      params: params,
      count: result['entries'] ? result['entries'].count : 0,
      result: result['entries'].sort_by { |h| h['upload_date'] }
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
