# frozen_string_literal: true

class CrowdtangleController < ApplicationController
  include Response

  def index
    default_date
    result = Crowdtangle.search(params)
    respond_to do |format|
      format.json { 
        render json: download_link.merge(Crowdtangle.count_result(params)) 
      }
      format.csv do
        send_data(
          a_to_csv(Crowdtangle.search(params), 'id platformId platform date updated type description expandedLinks link postUrl subscriberCount score media stastics account'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
