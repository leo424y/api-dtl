# frozen_string_literal: true

class FblinksController < ApplicationController
  include Response
  def index 
    start_date = params[:start_date] ? params[:start_date].to_date : Date.today
    end_date = params[:end_date] ? params[:end_date].to_date : Date.today
    @fblinks = Fblink.where("to_date(updated, 'YY-MM-DD') BETWEEN ? AND ?", start_date.beginning_of_day, end_date.end_of_day)
    @fblinks = @fblinks.where("title LIKE ?", "%#{params[:content]}%") if params[:content]
    if params[:list]
      list =  Ctlist.find_by(creator: params[:list]) 
      listid = list ? list.listid : params[:list]
      @fblinks = @fblinks.where("list LIKE ?", "#{listid}")
    end
    if params[:domain]
      @fblinks = @fblinks.where(link_domain: params[:domain])
    else
      @fblinks= @fblinks.group(:link_domain).count.sort_by {|k,v| v}.reverse
    end
    json_response(@fblinks)
  end
end
