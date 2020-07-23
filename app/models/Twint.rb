# frozen_string_literal: true

class Twint < ApplicationRecord
  def self.count_result(params)
    data = %x(/home/deploy/.local/bin/twint -s #{params[:q]} --since "#{params[:start_date]} 00:00:00" --limit 100)
    result = data.split("\n").map do |x|
      row = x.split(' ')
      uid = row[4].delete('<>')
      {
        url: "https://twitter.com/#{uid}/status/#{row[0]}",
        date: row[1],
        twitter_id: uid,
        text: row[5..-1].join
      }
    end
    count = result ? result.count : 0 
    {
      status: 'ok',
      params: params,
      count: count,
      result: result.reverse
    }
  rescue StandardError => e
    {
      status: e
    }
  end
end
