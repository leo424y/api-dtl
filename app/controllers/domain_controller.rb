# frozen_string_literal: true

class DomainController < ApplicationController
  include Response

  def index
    result = Domain.count_result(params).as_json
    respond_to do |format|
      format.json { render json: download_link.merge(result) }
      format.csv do
        send_data(
          a_to_csv(result['result'], 'ctime url title description'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
