class VideosController < ApplicationController

  def update
    @video = Video.find_by_id(params[:id])
    @video.media_attachment.update_attributes(params[:video][:media_attachment_attributes])
    @video.thumbnail = params[:video][:thumbnail] if params[:video][:thumbnail].present?
    @video.save

    render :show
  end

  def show
    @video = Video.find_by_id(params[:id])
  end

end
