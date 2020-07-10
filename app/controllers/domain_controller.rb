# frozen_string_literal: true

class DomainController < ApplicationController
  include Response

  def index
    respond_to do |format|
      format.json { render json: Domain.count_result(params) }
    end
  end
end
