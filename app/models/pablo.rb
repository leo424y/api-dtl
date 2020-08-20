# frozen_string_literal: true

class Pablo < ApplicationRecord
  def self.result(params)
    rows = []
    count_daily = count_daily(params)
    count_daily.each do |x|
      (1..(x[:page_count].to_i)).each do |c|
        response = Timeout.timeout(30) { Net::HTTP.get_response(pablo_date_page(params[:q], x[:date], c)) }
        body = JSON.parse(response.body)['body']
        rows += body['list']
      end
    end
    rows
  rescue StandardError => e
    {
      status: e
    }
  end

  def self.count_result(params)
    uri = pablo_uri(params)
    response = Timeout.timeout(30) { Net::HTTP.get_response(uri) }
    body = JSON.parse(response.body)['body']
    count = body['totalRows']
    page_count = body['pageCount']
    result = {
      status: 'ok',
      params: params,
      count: count,
    }
    # if count.to_i < 101
    result = result.merge({ posts_by_date: body['list'].sort_by { |h| h['pubTime'] } })
    # end
    if params[:view] == 'all'
      result = result.merge({ count_daily: count_daily(params) })
      end
    result
  rescue StandardError => e
    {
      status: e
    }
  end

  def self.count_daily(params)
    rows = []
    dates = params[:start_date].to_date..params[:end_date].to_date
    dates.each do |x|
      date = x.strftime('%Y-%m-%d')
      response = Timeout.timeout(30) { Net::HTTP.get_response(pablo_uri_date(params[:q], date)) }
      body = JSON.parse(response.body)['body']
      total_rows = body['totalRows']
      page_count = body['pageCount']
      rows << { date: date, total_rows: total_rows, page_count: page_count }
    end
    rows
  rescue StandardError => e
    {
      status: e
    }
  end

  def self.pablo_uri(params)
    p = URI.encode_www_form(keyword: (tradsim params[:q]))
    URI.parse("#{ENV['PABLO_API']}&#{p}&position=1&emotion=&startTime=#{params[:start_date]}&endTime=#{params[:end_date]}&pageIndex=1&pageRows=100")
  end

  def self.pablo_uri_date(q, date)
    p = URI.encode_www_form(keyword: (tradsim params[:q]))
    URI.parse("#{ENV['PABLO_API']}&#{p}}&position=1&emotion=&startTime=#{date}&endTime=#{date}&pageIndex=1&pageRows=100")
  end

  def self.pablo_date_page(q, date, page)
    p = URI.encode_www_form(keyword: (tradsim params[:q]))
    URI.parse("#{ENV['PABLO_API']}&#{p}&position=1&emotion=&startTime=#{date}&endTime=#{date}&pageIndex=#{page}&pageRows=100")
  end

  def self.tradsim(q)
    iparams = q.split(' ')
    "(#{(iparams).join('+')})|(#{iparams.map{|x| Tradsim::to_sim(x)}.join('+')})"
  end
end
