# frozen_string_literal: true

class CrowdtangleController < ApplicationController
  include Response

  def index 
    log_search
    result = Crowdtangle.search(params)
    respond_to do |format|
      format.json { render json: api_result(params, result)}
      format.csv { send_data a_to_csv(result, 'id platformId platform date updated type description expandedLinks link postUrl subscriberCount score media stastics account'), filename: "crowdtangle-#{Date.today}-#{params[:q]}-from-#{params[:start_date]}-to-#{params[:end_date]}.csv" }
    end  
  end
end