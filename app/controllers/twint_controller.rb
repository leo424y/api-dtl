# frozen_string_literal: true

class TwintController < ApplicationController
  include Response

  def index
    default_date
    result = Twint.count_result(params).as_json
    respond_to do |format|
      format.json { render json: download_link.merge(result) }
      format.csv do
        send_data(
          a_to_csv(result['result'], 'date twitter_id text url'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
