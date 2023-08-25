class StaticPagesController < ApplicationController

  layout "static"
 
  def about
  end

  def advertise
  end

  def privacy
  end

  def terms
  end

  def shopper_thank_you
    render layout: "application_v_2"
  end

  def business_thank_you
  end
end