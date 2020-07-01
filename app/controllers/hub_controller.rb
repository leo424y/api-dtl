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
    @hub_wikipedia = Wikipedia.count_result(params)
    render partial: "hub_wikipedia"
  end

  def hub_claim
    @hub_claim = Claim.count_result(params)
    render partial: "hub_claim" if @hub_claim.count > 0
  end

  def hub_cofact
    @hub_cofact = Cofact.count_result(params)
    render partial: "hub_cofact" if (@hub_cofact.count > 0)
  end
end


