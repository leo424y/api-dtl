# frozen_string_literal: true

class Hub < ApplicationRecord
  def self.result(params)
    param = ''
    params.each {|k,v| param += "&#{k}=#{v}" if ( %w(format controller action).exclude? k)}

    ct_search = URI.parse "https://api.doublethinklab.org/fblinks?#{URI.escape param}"
    ct_result = JSON.parse(Timeout.timeout(30) { Net::HTTP.get_response(ct_search) }.body)
    ct_count = ct_result['count']

    cofact_result = api_result('cofact', param)
    pablo_result = api_result('pablo', param)
    crowdtangle_result = api_result('crowdtangle', param)

    result = []
    if params[:q]
      result += [
        {
          platform: 'cofact',
          url: "https://api.doublethinklab.org/cofact?q=#{params[:q]}",
          download: "https://api.doublethinklab.org/cofact.csv?q=#{params[:q]}",
          document: 'https://github.com/doublethinklab/API/wiki/cofact',
          count: cofact_result['count'],
          first_result: cofact_result['posts_by_date'][0]['createdAt'],
          note: 'The maximum of count is 200. The result is a full history search.'
        },
        {
          platform: 'fblinks',
          url: "https://api.doublethinklab.org/fblinks?#{param}",
          download: "https://api.doublethinklab.org/fblinks.csv?#{param}",
          document: 'https://github.com/doublethinklab/API/wiki/fblinks',
          count: ct_count, 
          first_result: (ct_result['posts_by_date'][0]['date'] if ct_result['posts_by_date'].present?),
          note: 'Show links shared on Facebook which was traced by DoubleThink Lab.'
        }
      ]
    end
    if params[:start_date].present? && params[:end_date].present?
      result += [
        {
          platform: 'pablo',
          url: "https://api.doublethinklab.org/pablo?#{param}",
          download: "https://api.doublethinklab.org/pablo.csv?#{param}",
          document: 'https://github.com/doublethinklab/API/wiki/pablo',
          count: pablo_result['count'],
          first_result: (pablo_result['posts_by_date'][0]['pubTime'] if pablo_result['posts_by_date'].present?),
          note: 'The results are matched in Chinese Traditional or Chinese Simplify'
        },
        {
          platform: 'crowdtangle',
          url: "https://api.doublethinklab.org/crowdtangle?#{param}",
          download: "https://api.doublethinklab.org/crowdtangle.csv?#{param}",
          document: 'https://github.com/doublethinklab/API/wiki/crowdtangle',
          count: crowdtangle_result['count'], 
          first_result: (crowdtangle_result['posts_by_date'][0]['date'] if crowdtangle_result['posts_by_date'].present?),
          note: 'The maximum of the count is 100. Sorting in interaction_rate'
        }
      ]
    end
    result
  end

  def self.api_result end_point, param
    begin
      url= URI.parse "https://api.doublethinklab.org/#{end_point}?#{URI.escape param}"
      JSON.parse(Timeout.timeout(30) { Net::HTTP.get_response(url) }.body)
    rescue => exception
      'timeout'
    end
  end
end
