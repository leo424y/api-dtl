# frozen_string_literal: true

class YoutuberController < ApplicationController
  include Response

  def index
    default_date
    result = Youtuber.count_result(params).as_json
    respond_to do |format|
      format.json { render json: download_link.merge(result) }
      format.csv do
        send_data(
          a_to_csv(result['result'], 'title url'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
