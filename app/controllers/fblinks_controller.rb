# frozen_string_literal: true

class FblinksController < ApplicationController
  include Response
  def record_count 
    log_search
    @fblinks = set_filter Fblink.all

    @result = {params: params, count: @fblinks.count}
    json_response(@result)
  end
end
