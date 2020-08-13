# frozen_string_literal: true

class CrowdtanglegoController < ApplicationController
  include Response

  def index
    default_date
    respond_to do |format|
      format.json { 
        render json: download_link.merge(Crowdtanglego.count_result(params)) 
      }
      format.csv do
        send_data(
          a_to_csv(Crowdtanglego.count_result(params).as_json['result'], 'page_name user_name facebook_id page_likes created post_type url message link final_link image_text link_text description total_interactions'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end

    