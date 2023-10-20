class GuideController < ApplicationController
  layout "community_guide"

  before_action :setup

  def index
    redirect_to guide_show_country_path :country => 'canada', :market => 'money'
  end

  def country
    @country = params[:country]
    @arg_type = 'country'

  end

  def province
    @arg_type = 'province'
    @province = params[:province]
  end

  def region
    @arg_type = 'region'
    @region = params[:region]
  end

  def community
    @arg_type = 'community'
    @community = params[:community]
  end


private

  def setup
    #@vertical_markets_all = VerticalMarket.at_depth 0
    @market_slug = @market_slug = cookies[:market] = (params.has_key?(:market) ? params[:market] : (cookies.has_key?(:market) ? cookies[:market] : 'money'))
    @vertical_market = VerticalMarket.find_by_slug(params.has_key?(:sub) ? params[:sub] : @market_slug )

  end

end