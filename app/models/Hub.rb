# frozen_string_literal: true

class Hub < ApplicationRecord
  def self.result(params)
    cofact_search= URI.parse "https://api.doublethinklab.org/cofact?q=#{URI.escape params[:q]}"
    cofact_count = JSON.parse(Timeout.timeout(30) { Net::HTTP.get_response(cofact_search) }.body)['count']

    ct_search= URI.parse "https://api.doublethinklab.org/fblinks?q=#{URI.escape params[:q]}"
    ct_count = JSON.parse(Timeout.timeout(30) { Net::HTTP.get_response(ct_search) }.body)['count']

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
          url: "https://api.doublethinklab.org/fblinks?q=#{params[:q]}",
          download: "https://api.doublethinklab.org/fblinks.csv?q=#{params[:q]}",
          document: 'https://github.com/doublethinklab/API/wiki/fblinks',
          count: ct_count
        }
      ]
    end
    if params[:start_date] && params[:end_date]
      result += [
        {
          platform: 'pablo',
          url: "https://api.doublethinklab.org/pablo?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          download: "https://api.doublethinklab.org/pablo.csv?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          document: 'https://github.com/doublethinklab/API/wiki/pablo'
        },
        {
          platform: 'crowdtangle',
          url: "https://api.doublethinklab.org/crowdtangle?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          download: "https://api.doublethinklab.org/crowdtangle.csv?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          document: 'https://github.com/doublethinklab/API/wiki/crowdtangle'
        }
      ]
    end
    result
  end
end
