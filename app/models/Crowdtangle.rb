# frozen_string_literal: true

class Crowdtangle < ApplicationRecord
  def self.count_result(params)
    api_result(params, search(params), 'crowdtangle')
  end

  def self.search(params)
    begin
      token = ENV['CT_TOCKEN']
      p = URI.encode_www_form(searchTerm: params[:q].split(' ').map{|x| "'#{x}'"}.join(' '))
      uri = URI("https://api.crowdtangle.com/posts/search/?token=#{token}&#{p}&platforms=#{params[:platforms]}&accountTypes=#{params[:account_types]}&startDate=#{params[:start_date]}&endDate=#{(params[:end_date].to_date + 1.day).strftime('%F')}&sortBy=date&count=100&minSubscriberCount=50000")
      request = JSON.parse(Net::HTTP.get_response(uri).body)

      request['result']['posts'] 
    rescue => e  
      e
    end
  end

  def self.ct_api_import
    ct_api_import_by('posts', 'date', 100)
  end

  def self.ct_api_import_by(endpoints, sort_by, count)
    require 'net/https'
    token = ENV['CT_TOCKEN']
    list_id = Ctlist.all[Time.now.strftime('%M').to_i % Ctlist.count].listid
    uri = URI("https://api.crowdtangle.com/#{endpoints}?token=#{token}&listIds=#{list_id}&startDate=#{Date.today.strftime('%Y-%m-%d')}&sortBy=#{sort_by}&count=#{count}")
    request = Net::HTTP.get_response(uri)
    rows_hashs = JSON.parse(request.body)['result']['posts']
    rows_hashs.each do |row_hash|
      extlink = (row_hash['expandedLinks'].present? ? row_hash['expandedLinks'][0]['expanded'] : row_hash['link'])
      if ((row_hash['type'] == 'link') || (row_hash['type'] == 'youtube')) && (row_hash['platform'] == 'Facebook')
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
                        platform_name: [row_hash['account']['name'], row_hash['account']['handle']].join(' ')
                      })
      end
      %x(cd '/Volumes/GoogleDrive/My Drive/_Movies/dtl/_facebook_watch'; youtube-dl --sleep-interval 60 --default-search "ytsearch" --write-info-json --all-subs --download-archive "archive.txt" -o "%(uploader)s/%(id)s_%(title)s.%(ext)s" #{extlink}) if ((extlink =~ /facebook/) && (extlink =~ /videos/) && Rails.env == 'development')
      %x(cd '/Volumes/GoogleDrive/My Drive/_Movies/dtl/_youtube_watch'; youtube-dl --sleep-interval 60 --default-search "ytsearch" --write-info-json --all-subs --download-archive "archive.txt" -o "%(uploader)s/%(id)s_%(title)s.%(ext)s" #{extlink}) if ((extlink =~ /youtube.com|youtu.be/) && Rails.env == 'development') 
    rescue StandardError => e
      p e
    end
  end
end
