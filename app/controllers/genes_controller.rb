# frozen_string_literal: true

class GenesController < ApplicationController
  include Response

  def index
    @genes = set_filter Gene.all
    result = if params[:group_by]
               @genes.group(params[:group_by].to_sym).count.sort_by { |_k, v| v }.reverse
             else
               count_record @genes
    end

    respond_to do |format|
      format.json { render json: (result.is_a?(Hash) ? download_link.merge(result) : result) }
      format.csv do
        send_data(
          @genes.to_csv('id media url title iamge tags created_time description'),
          filename: name_file(controller_name, params)
        )
      end
    end
  end
end
