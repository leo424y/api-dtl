# frozen_string_literal: true

class Youtuber < ApplicationRecord
  def self.count_result(params)
    p = URI.encode_www_form(q: params[:q])
    uri = URI("https://#{ENV['CTCSVHOST']}/youtubes?#{p}")
    result = Timeout.timeout(50) { 
      JSON.parse(Net::HTTP.get_response(uri).body)
    } 
    # result.each do |r|
    #   begin
    #     yt_to_dtl r, params[:q]
    #   rescue => exception
    #     p exception
    #   end
    # end
    {
      status: 'ok',
      params: params,
      count: result ? result.count : 0,
      result: result
    }
  rescue StandardError => e
    {
      status: e
    }
  end


  def self.yt_to_dtl r, search   
    host = "http://a.doublethinklab.org/graphql?"
    gql = <<~GQL
    mutation {
      createDtl(input: {
        source: "dtlyt"
        url: "#{r['url']}"
        channelId: "#{r['channelId']}"
        channelName: "#{r['channelTitle']}"
        link: ""
        domain: "youtube.com"
        title: "#{URI.encode_www_form_component r['title']}"
        description: "#{URI.encode_www_form_component r['description']}"
        content: ""
        pubTime: "#{r['publishedAt']}"
        search: "#{search}"
      }) {
        dtl {
          source
          url
          id
          uuid
          platformId
          channelId
          channelName
          link
          domain
          title
          description
          content
          pubTime
          search
        }
        errors
      }
    }
    GQL
    body = {
      query: gql,
    }

    HTTParty.post(
      host,
      body: body.to_json,
      headers: {'Content-Type': 'application/json',}
    )
  end
end
