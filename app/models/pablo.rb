class Pablo < ApplicationRecord
  def self.result params
    begin
        @rows = []
        dates = params[:start_date].to_date..params[:end_date].to_date
        dates.each{ |x|
          date = x.strftime("%Y-%m-%d")
          response = Timeout::timeout(30) { Net::HTTP.get_response(pablo_uri_date params[:q], date)}
          @rows += JSON.parse(response.body)['body']['list']  
        }
        @rows
    rescue => error
        {
            status: error,
        }
    end
  end

  def self.count_result params 
    begin
    response = Timeout::timeout(30) { Net::HTTP.get_response(pablo_uri params)}
    counts = JSON.parse(response.body)['body']['totalRows']
    {
        status: 'ok',
        source: 'pablo',
        params: params,
        counts: counts,
    }
    rescue => error
    {
        status: error,
    }
    end
  end

  def self.pablo_uri params
    URI.parse("#{ENV['PABLO_API']}&keyword=#{URI.escape(params[:q])}&position=1&emotion=1&startTime=#{params[:start_date]}&endTime=#{params[:end_date]}&pageIndex=1&pageRows=9999")    
  end

  def self.pablo_uri_date q, date
    URI.parse("#{ENV['PABLO_API']}&keyword=#{URI.escape(q)}&position=1&emotion=1&startTime=#{date}&endTime=#{date}&pageIndex=1&pageRows=50")    
  end
end