# frozen_string_literal: true

class FblinksController < ApplicationController
  include Response
  def index 
    the_date = params[:date] ? params[:date].to_date : Date.today
    @fblinks = Fblink.where("to_date(updated, 'YY-MM-DD') BETWEEN ? AND ?", the_date.beginning_of_day, the_date.end_of_day)
    @fblinks = @fblinks.where("title LIKE ?", "%#{params[:content]}%") if params[:content]
    if params[:listid]
      list =  Ctlist.find_by(creator: params[:listid]) 
      listid = list ? list.listid : params[:listid]
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
