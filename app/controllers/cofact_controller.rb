# frozen_string_literal: true

class CofactController < ApplicationController
  include Response

  def index 
    log_search
    result = (Rumors::Api::Client.search params[:q])
    respond_to do |format|
      format.json {render json: api_result(params, result)}
      format.csv { 
        send_data(
          a_to_csv(result, 'id text createdAt updatedAt hyperlinks articleReplies'),
          filename: name_file(controller_name, params) 
        )
      }
    end
  end
end