# frozen_string_literal: true

class HubController < ApplicationController
  include Response

  def index
    result = Hub.result params
    respond_to do |format|
      format.json { render json: result }
    end
  end
end
