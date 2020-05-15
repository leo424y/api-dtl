class Crowdtangle < ApplicationRecord
  def self.search params
      require 'net/https'
      token = ENV['CT_TOCKEN']
      uri = URI("https://api.crowdtangle.com/posts/search/?token=#{token}&searchTerm=#{URI.escape params[:description]}&startDate=#{params[:start_date]}&endDate=#{(params[:end_date].to_date+1.day).strftime("%Y-%m-%d")}&sortBy=&count=100")
      request = Net::HTTP.get_response(uri)
      rows_hash = JSON.parse(request.body)['message'] || JSON.parse(request.body)['result']['posts']
      api_result 'crowdtangle', params, rows_hash
  end

  def self.ct_api_import
    ct_api_import_by('posts','date', 100)
  end

  def self.ct_api_import_by(endpoints, sort_by, count)
    require 'net/https'
    token = ENV['CT_TOCKEN']
    list_ids = Ctlist.pluck(:listid)
    list_ids.each do |list_id|
        uri = URI("https://api.crowdtangle.com/#{endpoints}?token=#{token}&listIds=#{list_id}&startDate=#{Date.today.strftime("%Y-%m-%d")}&sortBy=#{sort_by}&count=#{count}")
        request = Net::HTTP.get_response(uri)
        rows_hashs = JSON.parse(request.body)['result']['posts']
        rows_hashs.each do |row_hash|
          extlink = (row_hash['expandedLinks'].present? ? row_hash['expandedLinks'][0]['expanded'] : row_hash['link'])
          Fblink.create({
            url: row_hash['postUrl'], 
            title: [row_hash['title'], row_hash['description'], row_hash['message'], row_hash['title']].join(' '),
            link: extlink, 
            link_domain: row_hash['caption'] || URI(extlink).host,
            date: row_hash['date'],
            updated: row_hash['updated'],
            score: row_hash['score'],
            list: list_id,
            platform_id: row_hash['account']['platformId'],
            platform_name: [row_hash['account']['name'], row_hash['account']['handle']].join(' '),
          }) if (row_hash['type'] == 'link') || (row_hash['type'] == 'youtube') && (row_hash['platform'] == 'Facebook')
        end
    end
  end
end