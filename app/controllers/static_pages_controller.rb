class StaticPagesController < ActionController::Base
  include NavigationHelper

  layout "static"

  before_filter :setup_navigation
  
  def about
  end

  def privacy
  end

  def terms
  end

end