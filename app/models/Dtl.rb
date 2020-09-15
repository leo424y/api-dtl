# frozen_string_literal: true

class Dtl < ApplicationRecord
  def self.count_result(params)
    host = "http://a.doublethinklab.org/graphql?"
    gql = <<~GQL
    query{
      allDtls(filter: {textContains: "#{params[:q]}"}, order: PUBLISHED){
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
