# frozen_string_literal: true

class HubController < ApplicationController
  include Response
  def index
    log_search
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

  def hub_crowdtangle
    default_date
    @hub_crowdtangle = Crowdtangle.count_result(params)
    render partial: "hub_crowdtangle" if (@hub_crowdtangle.count < 101 && @hub_crowdtangle.count > 0)
  end

  def hub_pablo
    default_date
    @hub_pablo = Pablo.count_result(params)
    render partial: "hub_pablo" if (@hub_pablo.count < 101 && @hub_pablo.count > 0)
  end

  def hub_fblink
    @hub_fblink = count_record set_filter(Fblink.all)
    render partial: "hub_fblink" if (@hub_fblink.count > 0)
  end  
end


