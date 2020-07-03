# frozen_string_literal: true

class WikipediaController < ApplicationController
  include Response

  def index
    respond_to do |format|
      format.json { render json: Wikipedia.count_result(params) }
    end
  end
end
