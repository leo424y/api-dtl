class Hub < ApplicationRecord
  def self.result params
    result = []
    result += [
        {platform: "cofact", url: "https://api.doublethinklab.org/cofact?q=#{params[:q]}"},
        {platform: "fblinks", url: "https://api.doublethinklab.org/fblinks?q=#{params[:q]}"}
        ] if params[:q]
    result+=[
        { platform: "pablo", url: "https://api.doublethinklab.org/pablo?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}"},
        { platform: "crowdtangle", url: "https://api.doublethinklab.org/crowdtangle?q=#{params[:q]}&start_date=#{params[:start_date]}&end_date=#{params[:end_date]}"}
        ] if params[:start_date] && params[:end_date]
    result
  end
end