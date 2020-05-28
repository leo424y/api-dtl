# frozen_string_literal: true

class CrowdtangleController < ApplicationController
  include Response

  def index
    log_search
    result = Crowdtangle.search(params)
    respond_to do |format|
      format.json { 
        render json: download_link.merge(api_result(params, result)) 
      }
      format.csv do
        send_data(
          a_to_csv(result, 'id platformId platform date updated type description expandedLinks link postUrl subscriberCount score media stastics account'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
