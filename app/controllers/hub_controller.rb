# frozen_string_literal: true

class HubController < ApplicationController
  include Response
  def index
    # result = Hub.result params 
    respond_to do |format|
      format.html
      # format.json { render json: result }
    end
  end

  def hub_wikipedia 
    wiki = Wikipedia.count_result(params)
    @hub_wikipedia = wiki
    render partial: "hub_wikipedia"
  end
end
