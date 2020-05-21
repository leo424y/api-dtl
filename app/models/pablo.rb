class Pablo < ApplicationRecord
  def self.result params
    begin
      rows = []
      count_daily = count_daily(params)
      count_daily.each do |x|
        p x[:page_count] 
        p x[:date]
        (1..(x[:page_count].to_i)).each do |c|
          p c
          response = Timeout::timeout(30) { Net::HTTP.get_response(pablo_date_page params[:q], x[:date], c)}
          body = JSON.parse(response.body)['body']
          rows += body['list']  
        end
      end
      rows
    rescue => error
      {
        status: error,
      }
    end
  end

  def self.count_result params 
    begin
    response = Timeout::timeout(30) { Net::HTTP.get_response(pablo_uri params)}
    body = JSON.parse(response.body)['body']
    counts = body['totalRows']
    page_count = body['pageCount']
    {
      status: 'ok',
      params: params,
      counts: counts,
      count_daily: count_daily(params),
    }
    rescue => error
    {
      status: error,
    }
    end
  end

  def self.count_daily params 
    begin
      rows = []
      dates = params[:start_date].to_date..params[:end_date].to_date
      dates.each { |x|
        date = x.strftime("%Y-%m-%d")
        response = Timeout::timeout(30) { Net::HTTP.get_response(pablo_uri_date params[:q], date)}
        body = JSON.parse(response.body)['body']
        total_rows = body['totalRows']
        page_count = body['pageCount']    
        rows << {date: date, total_rows: total_rows, page_count: page_count}
      }
      rows
    rescue => error
      {
        status: error,
      }
    end
  end  

  def self.pablo_uri params
    URI.parse("#{ENV['PABLO_API']}&keyword=#{URI.escape(params[:q])}&position=1&emotion=1&startTime=#{params[:start_date]}&endTime=#{params[:end_date]}&pageIndex=1&pageRows=100")    
  end

  def self.pablo_uri_date q, date
    URI.parse("#{ENV['PABLO_API']}&keyword=#{URI.escape(q)}&position=1&emotion=1&startTime=#{date}&endTime=#{date}&pageIndex=1&pageRows=100")    
  end

  def self.pablo_date_page q, date, page
    URI.parse("#{ENV['PABLO_API']}&keyword=#{URI.escape(q)}&position=1&emotion=1&startTime=#{date}&endTime=#{date}&pageIndex=#{page}&pageRows=100")    
  end
end