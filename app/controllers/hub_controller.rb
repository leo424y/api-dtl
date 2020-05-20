# frozen_string_literal: true

class HubController < ApplicationController
  include Response

  def index 
    @pablos = Pablo.result params
    respond_to do |format|
      format.json { render json: @pablos }
      format.csv { send_data a_to_csv(@pablos, 'content creator domain pubTime siteName title url'), filename: "hub-#{Date.today}-#{params.inspect}.csv" }
    end  
  end
end