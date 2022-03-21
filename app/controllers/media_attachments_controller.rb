class MediaAttachmentsController < ApplicationController

  load_resource :location
  skip_load_resource :location, only: [:vonage_archive_callback, :get_vonage_token]
  load_and_authorize_resource :media_attachment, through: [:location]
  skip_load_and_authorize_resource :media_attachment, only: [:vonage_archive_callback, :get_vonage_token]

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

    if @media_attachment.archive_id.present?
      url = vonage.get_archive(@media_attachment.archive_id).url
      @media_attachment.update_attribute(:stream_video_url, url)
    end
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

  def start_archive
    archive = vonage.create_archive(params)
    if archive.present?
      media_attachment = @location.media_attachments.new(
        is_stream_video: true,
        stream_video_name: archive.name,
        archive_id: archive.id,
        session_id: archive.sessionId,
        has_audio: archive.hasAudio,
        has_video: archive.hasVideo,
        status: archive.status
      )

      if media_attachment.save
        render nothing: true, status: :created
      else
        render nothing: true, status: :unprocessable_entity
      end
    else
      render json: {msg: "Failed to connect to OpenTok"}, status: :error
    end
  end

  def stop_archive
    archive = vonage.stop_archive(params)
    media_attachment = MediaAttachment.find_by_archive_id(params[:archive_id])
    media_attachment.update_attribute(:status, "stopped") if media_attachment.present?

    render nothing: true, status: :ok
  end

  def vonage_archive_callback
    media_attachment = MediaAttachment.find_by_archive_id(params[:id])

    if media_attachment.present?
      media_attachment.update_attribute(:status, params[:status])
      vonage.create_thumbnail(params[:id]) if params[:status] == "available"
    end
    render nothing: true, status: :ok
  end

  def get_vonage_token
    session_id = vonage.get_session_id
    token = vonage.get_token(session_id)
    render json: { session_id: session_id, token: token }
  end

  def vonage
    @vonage ||= VonageService.new
  end
end
