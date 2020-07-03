# frozen_string_literal: true

class CofactController < ApplicationController
  include Response

  def index
    result = Cofact.count_result params
    respond_to do |format|
      format.json { render json: result}
      format.csv do
        send_data(
          a_to_csv(Rumors::Api::Client.search params[:q], 'id text createdAt updatedAt hyperlinks articleReplies'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
