class Pablo < ApplicationRecord
  def self.result (params)
      require 'net/http'
      uri = URI.parse("#{ENV['PABLO_API']}&keyword=#{URI.escape(params[:q])}&position=1&emotion=1&startTime=#{params[:start_date]}&endTime=#{params[:end_date]}&pageIndex=1&pageRows=99999")
      begin
          response = Timeout::timeout(28) { Net::HTTP.get_response(uri)}
          rows_hash = JSON.parse(response.body)['body']['list']
          # {
          #         source: 'pablo',
          #         params: params,
          #         status: 200,
          #         count: rows_hash.count, 
          #         posts: rows_hash,
          # }
          rows_hash
      rescue
          {
                  source: 'pablo',
                  params: params,
                  status: 'timeout',
          }
      end
  end
end