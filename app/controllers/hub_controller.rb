# frozen_string_literal: true

class HubController < ApplicationController
  include Response
  def index
    default_date
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
    @gf_count = @hub_claim.count 
    @gf_dl = download_link_of 'claim'
    render partial: "hub_claim" 
  end

  def hub_cofact
    @hub_cofact = Cofact.count_result(params).as_json['posts_by_date']
    @cf_count = @hub_cofact.count
    @cf_dl = download_link_of 'cofact'
    render partial: "hub_cofact" 
  end

  def hub_crowdtangle
    crowdtangle = Crowdtangle.count_result(params).as_json
    @hub_crowdtangle = crowdtangle['posts_by_date']
    # @hub_crowdtangle = data_compact @hub_crowdtangle, 'caption'

    @ct_count = crowdtangle['count']
    @ct_dl = download_link_of 'crowdtangle'
    render partial: "hub_crowdtangle" 
  end

  ################ page, group, profile should be delay 60s each, in case it hit the API limit 
  def hub_crowdtanglego
    @crowdtanglego = Crowdtanglego.count_result(params).as_json['result']
    @ctgo_dl = download_link_of 'crowdtanglego'
    render partial: "hub_crowdtanglego" 
  end

  def hub_crowdtangle_page
    params[:platforms] = 'facebook'
    params[:account_types] = 'facebook_page'
    crowdtangle = Crowdtangle.count_result(params).as_json
    @hub_crowdtangle_page = crowdtangle['posts_by_date']
    @hub_crowdtangle_page = data_compact @hub_crowdtangle_page, 'caption'

    @ct_count_page = crowdtangle['count']
    @ct_dl_page = download_link_of 'crowdtangle'
    render partial: "hub_crowdtangle_page" 
  end

  def hub_crowdtangle_group
    sleep 10
    params[:platforms] = 'facebook'
    params[:account_types] = 'facebook_group'
    crowdtangle = Crowdtangle.count_result(params).as_json
    @hub_crowdtangle_group = crowdtangle['posts_by_date']
    @hub_crowdtangle_group = data_compact @hub_crowdtangle_group, 'caption'

    @ct_count_group = crowdtangle['count']
    @ct_dl_group = download_link_of 'crowdtangle'
    render partial: "hub_crowdtangle_group" 
  end

  def hub_crowdtangle_profile
    sleep 20
    params[:platforms] = 'facebook'
    params[:account_types] = 'facebook_profile'
    crowdtangle = Crowdtangle.count_result(params).as_json
    @hub_crowdtangle_profile = crowdtangle['posts_by_date']
    # @hub_crowdtangle_profile = data_compact @hub_crowdtangle_profile, 'caption'

    @ct_count_profile = crowdtangle['count']
    @ct_dl_profile = download_link_of 'crowdtangle'
    render partial: "hub_crowdtangle_profile" 
  end

  def hub_crowdtangle_instagram
    sleep 30
    params[:platforms] = 'instagram'
    crowdtangle = Crowdtangle.count_result(params).as_json
    @hub_crowdtangle_instagram = crowdtangle['posts_by_date']
    # @hub_crowdtangle_profile = data_compact @hub_crowdtangle_profile, 'caption'

    @ct_count_instagram = crowdtangle['count']
    @ct_dl_instagram = download_link_of 'crowdtangle'
    render partial: "hub_crowdtangle_instagram" 
  end

  def hub_crowdtangle_reddit
    sleep 40
    params[:platforms] = 'reddit'
    crowdtangle = Crowdtangle.count_result(params).as_json
    @hub_crowdtangle_reddit = crowdtangle['posts_by_date']
    # @hub_crowdtangle_profile = data_compact @hub_crowdtangle_profile, 'caption'

    @ct_count_reddit = crowdtangle['count']
    @ct_dl_reddit = download_link_of 'crowdtangle'
    render partial: "hub_crowdtangle_reddit" 
  end
  ################


  def hub_pablo
    @hub_pablo = Pablo.count_result(params).as_json['posts_by_date'] 
    @hub_pablo = data_compact @hub_pablo, 'siteName'

    @dt_count = @hub_pablo.count
    @dt_dl = download_link_of 'pablo'
    render partial: "hub_pablo" 
  end

  def hub_pablol
    pablo = Pablol.count_result(params).as_json
    @hub_pablol = data_compact pablo['result'], 'site_name'
    @da_count = pablo['count']
    @da_dl = download_link_of 'pablol'

    render partial: "hub_pablol"
  end

  def hub_media
    media = Media.count_result(params).as_json
    @hub_media = data_compact_host media['result'], 'url'
    @dm_count = media['count']
    @dm_dl = download_link_of 'media'
    render partial: "hub_media"
  end

  def hub_domain
    ds = Domain.count_result(params).as_json
    @hub_domain = data_compact_host ds['result'], 'url'
    @ds_count = ds['count']
    @ds_dl = download_link_of 'domain'
    render partial: "hub_domain"
  end

  def hub_twint
    @hub_twint = Twint.count_result(params).as_json['result']
    @tt_dl = download_link_of 'twint'
    @tt_count = @hub_twint.count
    render partial: "hub_twint"
  end

  def hub_youtube
    @hub_youtube = Youtube.count_result(params).as_json['result']
    @yt_dl = download_link_of 'youtube'
    @yt_count = @hub_youtube.count
    render partial: "hub_youtube"
  end

  def hub_fblinks
    fblink = count_record(set_filter(Fblink.all)).as_json
    @hub_fblink = fblink['posts_by_date']
    @hub_fblink = data_compact @hub_fblink, 'link_domain'
    @fb_count = fblink['count']
    @fb_dl = download_link_of 'fblinks'
    render partial: "hub_fblinks"
  end  

  def hub_datacount 
    render partial: "hub_datacount"
  end   
  
  private 
  def data_compact_host data, field
    items = []
    data.map do |x| 
      uri = x[field].split('/')[0..2].join('/')
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


