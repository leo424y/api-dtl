# frozen_string_literal: true

class PabloController < ApplicationController
  include Response

  def index 
    log_search
    respond_to do |format|
      format.json { render json: Pablo.count_result(params) }
      format.csv { send_data a_to_csv(Pablo.result(params), 'content creator domain pubTime siteName title url'), filename: "pablo-#{Date.today}-#{params[:q]}-from-#{params[:start_date]}-to-#{params[:end_date]}.csv" }
    end  
  end
end