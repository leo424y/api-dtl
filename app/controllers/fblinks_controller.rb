# frozen_string_literal: true

class FblinksController < ApplicationController
  include Response
  def index 
    @fblinks = Fblink.where("to_date(updated, 'YY-MM-DD') BETWEEN ? AND ?", Date.today.beginning_of_day, Date.today.end_of_day).group(:link_domain).count.sort_by {|k,v| v}.reverse
    json_response(@fblinks)
  end
end
