# frozen_string_literal: true

class MediaController < ApplicationController
  include Response

  def index
    respond_to do |format|
      format.json { render json: Media.count_result(params) }
    end
  end
end
