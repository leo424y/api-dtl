# frozen_string_literal: true

class Hub < ApplicationRecord
  def self.result(params)
    param = ''
    params.each {|k,v| param += "&#{k}=#{v}" if ( %w(format controller action).exclude? k)}

    cofact_search= URI.parse "https://api.doublethinklab.org/cofact?#{URI.escape param}"
    cofact_count = JSON.parse(Timeout.timeout(30) { Net::HTTP.get_response(cofact_search) }.body)['count']

    ct_search = URI.parse "https://api.doublethinklab.org/fblinks?#{URI.escape param}"
    ct_count = JSON.parse(Timeout.timeout(30) { Net::HTTP.get_response(ct_search) }.body)['count']

    pb_search = URI.parse "https://api.doublethinklab.org/pablo?#{URI.escape param}"
    pb_count = JSON.parse(Timeout.timeout(30) { Net::HTTP.get_response(pb_search) }.body)['count']

    result = []
    if params[:q]
      result += [
        {
          platform: 'cofact',
          url: "https://api.doublethinklab.org/cofact?q=#{params[:q]}",
          download: "https://api.doublethinklab.org/cofact.csv?q=#{params[:q]}",
          document: 'https://github.com/doublethinklab/API/wiki/cofact',
          count_max_200: cofact_count
        },
        {
          platform: 'fblinks',
          url: "https://api.doublethinklab.org/fblinks?#{param}",
          download: "https://api.doublethinklab.org/fblinks.csv?#{param}",
          document: 'https://github.com/doublethinklab/API/wiki/fblinks',
          count: ct_count
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
          count: pb_count
        },
        {
          platform: 'crowdtangle',
          url: "https://api.doublethinklab.org/crowdtangle?#{param}",
          download: "https://api.doublethinklab.org/crowdtangle.csv?#{param}",
          document: 'https://github.com/doublethinklab/API/wiki/crowdtangle'
        }
      ]
    end
    result
  end
end
