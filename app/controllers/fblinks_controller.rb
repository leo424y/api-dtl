# frozen_string_literal: true

class FblinksController < ApplicationController
  include Response
  def record_count 
    log_search
    fblinks = set_filter Fblink.all
    json_response(count_record fblinks)
  end
end
