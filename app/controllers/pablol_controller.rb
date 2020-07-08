# frozen_string_literal: true

class PablolController < ApplicationController
  include Response

  def index
    respond_to do |format|
      format.json { render json: download_link.merge(Pablol.count_result(params)) }
      format.csv do
        send_data(
          a_to_csv(Pablol.count_result(params).as_json['result'], 'url title summary creator domain pub_time channel_name'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
