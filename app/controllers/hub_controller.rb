# frozen_string_literal: true

class HubController < ApplicationController
  include Response
  def index
    $gf_count = $cf_count = $ct_count = $dt_count = $dm_count = $da_count = $ds_count = $fb_count = 0
    log_search
    respond_to do |format|
      format.html
      # format.json { render json: result }
    end
  end

  def hub_wikipedia 
    @hub_wikipedia = Wikipedia.count_result(params)
    render partial: "hub_wikipedia"
  end

  def hub_claim
    @hub_claim = Claim.count_result(params).as_json['result']
    $gf_count = @hub_claim.count 
    $gf_dl = download_link_of 'claim'
    render partial: "hub_claim" if @hub_claim.count > 0
  end

  def hub_cofact
    @hub_cofact = Cofact.count_result(params).as_json['posts_by_date']
    $cf_count = @hub_cofact.count
    $cf_dl = download_link_of 'cofact'
    render partial: "hub_cofact" if (@hub_cofact.count > 0)
  end

  def hub_crowdtangle
    default_date
    crowdtangle = Crowdtangle.count_result(params).as_json
    @hub_crowdtangle = crowdtangle['posts_by_date']
    @hub_crowdtangle = data_compact @hub_crowdtangle, 'caption'

    $ct_count = crowdtangle['count']
    $ct_dl = download_link_of 'crowdtangle'
    render partial: "hub_crowdtangle" if (@hub_crowdtangle.count < 101 && @hub_crowdtangle.count > 0)
  end

  def hub_pablo
    default_date
    @hub_pablo = Pablo.count_result(params).as_json['posts_by_date'] 
    @hub_pablo = data_compact @hub_pablo, 'siteName'

    $dt_count = @hub_pablo.count
    $dt_dl = download_link_of 'pablo'
    render partial: "hub_pablo" if (@hub_pablo.count < 101 && @hub_pablo.count > 0)
  end

  def hub_pablol
    pablo = Pablol.count_result(params).as_json
    @hub_pablol = data_compact pablo['result'], 'site_name'
    $da_count = pablo['count']
    $da_dl = download_link_of 'pablol'

    render partial: "hub_pablol"
  end

  def hub_media
    media = Media.count_result(params).as_json
    @hub_media = data_compact_host media['result'], 'url'
    $dm_count = media['count']
    $dm_dl = download_link_of 'media'
    render partial: "hub_media"
  end

  def hub_domain
    ds = Domain.count_result(params).as_json
    @hub_domain = data_compact_host ds['result'], 'url'
    $ds_count = ds['count']
    $ds_dl = download_link_of 'domain'
    render partial: "hub_domain"
  end

  def hub_fblinks
    fblink = count_record(set_filter(Fblink.all))
    @hub_fblink = fblink[:posts_by_date].as_json
    @hub_fblink = data_compact @hub_fblink, 'link_domain'
    $fb_count = fblink['count']
    $fb_dl = download_link_of 'fblinks'
    render partial: "hub_fblinks" if (@hub_fblink.count > 0)
  end  

  def hub_datacount 
    render partial: "hub_datacount"
  end   
  
  private 
  def data_compact_host data, field
    items = []
    data.map do |x| 
      uri = URI(URI.escape(x[field])).host
      unless items.include? uri
        items << uri
        x
      end
    end.compact
  end

  def data_compact data, field
    items = []
    data.map do |x| 
      unless items.include? x[field]
        items << x[field]
        x
      end
    end.compact
  end
end


