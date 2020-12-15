# frozen_string_literal: true

class DtlController < ApplicationController
  include Response

  def index
    default_date
    result = Dtl.count_result(params).as_json
    respond_to do |format|
      format.json { render json: download_link.merge(result) }
      format.csv do
        send_data(
          a_to_csv(result['result'], 'source id uuid url platformid link domain channelid channelName creatorId creatorName title description content pubTime'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end

  def daily_update_by_domain
    uri = "https://#{ENV['CTCSVHOST']}/count_domain?domain=#{params[:domain]}"
    %x(curl #{uri})
    render plain: "run counter for #{params[:domain]} ok"
  end
end
