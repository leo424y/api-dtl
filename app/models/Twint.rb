# frozen_string_literal: true

class Twint < ApplicationRecord
  def self.count_result(params)
    Timeout.timeout(30) { 
      p = URI.encode_www_form(q: params[:q], date: params[:start_date])
      uri = URI("http://#{ENV['SERVERIP']}:8080/?#{p}")
      Net::HTTP.get_response(uri)
    }
    sleep(15)
    result = Timeout.timeout(30) { 
      uri = URI("http://#{ENV['SERVERIP']}:9200/_search")
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = {"query":{"bool":{"must":[{"match":{"search":"#{params[:q]}"}},{"range":{"date":{"gte":"#{params[:start_date]} 00:00:00","lte":"#{params[:end_date]} 23:59:59"}}}],"must_not":[],"should":[]}},"from":0,"sort":[{"date": {"order": "asc"}}],"aggs":{}}.to_json
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      JSON.parse(res.body)['hits']['hits']
    }

    result = result.map do |x|
      x['_source']
    end
    
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
