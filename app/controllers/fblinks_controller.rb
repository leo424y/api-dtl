# frozen_string_literal: true

class FblinksController < ApplicationController
  include Response

  def index
    log_search
    @fblinks = set_filter Fblink.all
    result = if params[:group_by]
               @fblinks.group(params[:group_by].to_sym).count.sort_by { |_k, v| v }.reverse
             else
               count_record @fblinks
    end

    respond_to do |format|
      format.json { render json: result }
      format.csv do
        send_data(
          @fblinks.to_csv('id url link link_domain title date updated score created_at updated_at list platform_id platform_name'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
