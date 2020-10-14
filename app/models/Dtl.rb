# frozen_string_literal: true

class Dtl < ApplicationRecord
  def self.to_dtl(source: '', url: '', channel_id: '', channel_name: '', creator_id: '', creator_name: '', link: '', domain: '', title: '', description: '', content: '', pub_time: '', search: '')
    host = "http://a.doublethinklab.org/graphql?"
    gql = <<~GQL
    mutation {
      createDtl(input: {
        source: "#{source}"
        url: "#{url}"
        channelId: "#{channel_id}"
        channelName: "#{channel_name}"
        creatorId: "#{channel_id}"
        creatorName: "#{channel_name}"
        link: "#{link}"
        domain: "#{domain}"
        title: "#{URI.encode_www_form_component title}"
        description: "#{URI.encode_www_form_component description}"
        content: "#{URI.encode_www_form_component content}"
        pubTime: "#{pub_time.to_datetime}"
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
          creatorId
          creatorName
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

  def self.count_result(params)
    host = "http://a.doublethinklab.org/graphql?"
    gql = <<~GQL
    query{
      allDtls(filter: {textContains: "#{params[:q]}", pubTimeContains: "#{params[:start_date]}xxx#{params[:end_date]}"}, order: PUBLISHED){
        source
        uuid
        id
        url
        description
        content
        title
        pubTime
      }
    }
    GQL
    body = {
      query: gql,
    }

    # p = URI.encode_www_form(q: params[:q], start_date: params[:start_date], end_date: params[:end_date])
    result = Timeout.timeout(50) { 
      HTTParty.post(
        host,
        body: body.to_json,
        headers: {'Content-Type': 'application/json',}
      )
    } 
    result = result['data']['allDtls']
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
end
