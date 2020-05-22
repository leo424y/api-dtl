class Hub < ApplicationRecord
  def self.result params
    result = []
    result += [
        {
          platform: "cofact", 
          url: "https://api.doublethinklab.org/cofact?q=#{params[:q]}",
          download: "https://api.doublethinklab.org/cofact.csv?q=#{params[:q]}",
          document: "https://github.com/doublethinklab/API/wiki/cofact"
        },
        {
          platform: "fblinks", 
          url: "https://api.doublethinklab.org/fblinks?q=#{params[:q]}",
          download: "https://api.doublethinklab.org/fblinks.csv?q=#{params[:q]}",
          document: "https://github.com/doublethinklab/API/wiki/fblinks",
        }
        ] if params[:q]
    result+=[
        { 
          platform: "pablo", 
          url: "https://api.doublethinklab.org/pablo?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          download: "https://api.doublethinklab.org/pablo.csv?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          document: "https://github.com/doublethinklab/API/wiki/pablo",
        },
        { 
          platform: "crowdtangle", 
          url: "https://api.doublethinklab.org/crowdtangle?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          download: "https://api.doublethinklab.org/crowdtangle.csv?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}",
          document: "https://github.com/doublethinklab/API/wiki/crowdtangle",
        },
        ] if params[:start_date] && params[:end_date]
    result
  end
end