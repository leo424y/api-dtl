# frozen_string_literal: true

class YoutubeController < ApplicationController
  include Response

  def index
    default_date
    result = Youtube.count_result(params).as_json
    respond_to do |format|
      format.json { render json: download_link.merge(result) }
      format.csv do
        send_data(
          a_to_csv(result['result'], 'uploader uploader_id channel_id upload_date title description tags webpage_url view_count average_rating'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
