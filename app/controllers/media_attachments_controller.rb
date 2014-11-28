class MediaAttachmentsController < ApplicationController

  load_resource :location
  load_and_authorize_resource :media_attachment, through: [:location]

  def index
    @media_attachments = @location.media_attachments
  end

  def show

    @other_media = @location.media_attachments.all - [@media_attachment]

    @vertical_market = @location.vertical_market_categories.first.vertical_market
    add_crumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    # add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.broker.name, "#{@base_path}business/#{@location.broker.slug}" if @location.broker.present?
    add_crumb @location.name, location_path(@location)
    add_crumb 'Media'
  end

  def new
    @media_attachment = @location.media_attachments.new
  end

  def edit
  end

  def create
    @media_attachment = @location.media_attachments.new(params[:media_attachment])
    if @media_attachment.save
      redirect_to [@location, @media_attachment], notice: 'Media Attachment was successfully created.'
    else
      render action: :new
    end
  end

  def update
    if @media_attachment.update_attributes(params[:media_attachment])
      redirect_to [@location, @media_attachment], notice: 'Media Attachment was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @media_attachment.destroy
    redirect_to location_media_attachments_url
  end


end
