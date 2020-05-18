# frozen_string_literal: true

class BydaysController < ApplicationController
  skip_before_action :verify_authenticity_token

  include Response

  def index 
    start_date = params[:start_date] ? params[:start_date].to_date : Date.today
    end_date = params[:end_date] ? params[:end_date].to_date : Date.today
    @fblinks = Fblink.where("to_date(updated, 'YY-MM-DD') BETWEEN ? AND ?", start_date.beginning_of_day, end_date.end_of_day)
    if params[:list]
      list =  Ctlist.find_by(creator: params[:list]) 
      listid = list ? list.listid : params[:list]
      @fblinks = @fblinks.where("list LIKE ?", "#{listid}")
    end
    @fblinks = @fblinks.where(link_domain: params[:domain]) if params[:domain]

    @fblinks= @fblinks.group(:link_domain).count.sort_by {|k,v| v}.reverse
    json_response(@fblinks)
  end

  def indexx
    @byday = (params[:name] || params[:date]) ? Byday.all : Byday.none
    @byday = @byday.where(created_at: params[:date].to_date.beginning_of_day..params[:date].to_date.end_of_day) if params[:date]
    @byday = @byday.where("name LIKE ?", "%#{params[:name]}%") if params[:name]
    json_response(@byday)
  end

  def create
    @byday = Byday.new(name: params[:name], data: params[:data])

    if @byday.save
      json_response(@byday, :created)
    else
      json_response(status: 'not saved')
    end
  end
end
