# frozen_string_literal: true

class Twint < ApplicationRecord
  def self.count_result(params)
    # Timeout.timeout(30) { 
    #   p = URI.encode_www_form(q: params[:q], date: params[:start_date])
    #   uri = URI("http://#{ENV['SERVERIP']}:8080/?#{p}")
    #   Net::HTTP.get_response(uri)
    # }
    # sleep(15)
    # result = Timeout.timeout(30) { 
    #   uri = URI("http://#{ENV['SERVERIP']}:9200/_search")
    #   req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    #   req.body = {"query":{"bool":{"must":[{"match":{"search":{"query":"#{params[:q]}","operator": "and"}}},{"range":{"date":{"gte":"#{params[:start_date]} 00:00:00","lte":"#{params[:end_date]} 23:59:59"}}}],"must_not":[],"should":[]}},"from":0,"size":9999,"sort":[{"date": {"order": "asc"}}],"aggs":{}}.to_json
    #   res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    #     http.request(req)
    #   end
    #   JSON.parse(res.body)['hits']['hits']
    # }
    # require 'securerandom'
    # random_string = SecureRandom.hex
    # file_path = Rails.root.join("tmp/twitter/#{random_string}.json").to_s
    # %x(touch #{file_path})
    # %(rm #{file_path})
    results = %x(twint -s "#{params[:q]}" --since "#{(Date.today - 3.day).strftime("%Y-%m-%d")} 00:00:00" --limit 100).split("\n")
    sleep 10
    # results = File.readlines(file_path)
    results.each do |line|
      raw = line.split(' ')
      Dtl.to_dtl(
        source: 'dtltts',
        url: "https://twitter.com/_/status/#{raw[0]}",
        creator_id: raw[4] ? raw[4].delete('<>') : '',
        domain: 'twitter.com',
        title: raw[5..] ? raw[5..].join(' '): '',
        pub_time: (raw[1] && raw[2]) ? raw[1..2].join(' ').to_datetime - 14.hour : ''
      )
    end

    count = results ? results.count : 0
    {
      status: 'ok',
      params: params,
      count: count
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
