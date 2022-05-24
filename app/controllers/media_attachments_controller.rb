class MediaAttachmentsController < ApplicationController

  load_resource :location
  skip_load_resource :location, only: [:vonage_archive_callback, :get_vonage_token]
  load_and_authorize_resource :media_attachment, through: [:location]
  skip_load_and_authorize_resource :media_attachment, only: [:vonage_archive_callback, :get_vonage_token]
  PER_PAGE = 5

  def index
    @media_attachments = @location.media_attachments.page(params[:page]).per(PER_PAGE)
  end

  def show
    @other_media = @location.media_attachments.order("created_at ASC").all - [@media_attachment]

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
      @media_attachment.update_attribute(:is_draft, true)

      render action: :preview
    else
      render action: :new
    end
  end

  def preview

  end

  def update
    if @media_attachment.update_attributes(params[:media_attachment])
      @media_attachment.update_attribute(:is_draft, false)
      redirect_to [@location, @media_attachment], notice: 'Media Attachment was successfully updated.'
    else
      render action: :edit
    end
  end

  def preview
    @media_attachment = MediaAttachment.find_by_id(params[:media_attachment_id])
  end

  def destroy
    @media_attachment.destroy
    redirect_to location_media_attachments_url
  end

  def start_archive
    archive = vonage.create_archive(params)
    if archive.present?
      media_attachment = @location.media_attachments.new(
        is_draft: true,
        is_stream_video: true,
        title: params[:media_attachment][:title],
        description: params[:media_attachment][:description]
      )

      if media_attachment.save
        if media_attachment.videos.present?
          media_attachment.videos.destroy_all
        end
        video = media_attachment.videos.create(
          archive_id: archive.id,
          session_id: archive.sessionId,
          has_audio: archive.hasAudio,
          has_video: archive.hasVideo,
          status: archive.status,
        )
        if params[:thumbnail].present?
          video.thumbnail = params[:thumbnail]
          video.save
        end
        render nothing: true, status: :created
      else
        render nothing: true, status: :unprocessable_entity
      end
    else
      render json: {msg: "Failed to connect to OpenTok"}, status: :error
    end
  end

  def pause_archive
    archive = vonage.stop_archive(params)
    video = Video.find_by_archive_id(params[:archive_id])
    video.update_attribute(:status, "stopped") if video.present?

    render json: {media_attachment_id: video.media_attachment.id}, status: :ok
  end

  def stop_archive
    archive = vonage.stop_archive(params)
    video = Video.find_by_archive_id(params[:archive_id])
    video.update_attribute(:status, "stopped") if video.present?

    render json: {video_id: video.id}, status: :ok
  end

  def vonage_archive_callback
    video = Video.find_by_archive_id(params[:id])

    if video.present?
      video.update_attribute(:status, params[:status])
      if params[:status] == "uploaded"
        url = "https://#{ENV['S3_BUCKET_NAME']}.s3.#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['VONAGE_API_KEY']}/#{video.archive_id}/archive.mp4"
        video.update_attribute(:video_url, url)
      end
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
