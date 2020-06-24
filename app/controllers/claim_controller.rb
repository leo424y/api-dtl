# frozen_string_literal: true

class ClaimController < ApplicationController
  include Response

  def index
    log_search
    respond_to do |format|
      format.json { render json: Claim.count_result(params) }
    end
  end
end
