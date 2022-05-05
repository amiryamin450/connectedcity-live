class VideosController < ApplicationController

  def update
    @video = Video.find_by_id(params[:id])
    @video.media_attachment.update_attributes(params[:video][:media_attachment_attributes]) if params[:video][:media_attachment_attributes].present?
    @video.thumbnail = params[:video][:thumbnail] if params[:video][:thumbnail].present?
    @video.save

    if params[:video][:audio].present?
      cmd = "ffmpeg -i '#{@video.video_url}' -i '#{params[:video][:audio].path}' -map 0:v -map 1:a -c:v copy -shortest #{Rails.root}/public/archive.mp4"
      system( cmd )
      upload_video_to_s3
    end

    if params[:video][:remove_audio].present?
      cmd = "ffmpeg -i '#{@video.video_url}' -c copy -an #{Rails.root}/public/archive.mp4"
      system( cmd )
      upload_video_to_s3
    end

    render :show
  end

  def show
    @video = Video.find_by_id(params[:id])
  end

  private
  def upload_video_to_s3
    file = File.open("#{Rails.root}/public/archive.mp4")
    if file.present?
      s3 = AWS::S3.new
      bucket = s3.buckets["#{ENV['S3_BUCKET_NAME']}"]
      obj = bucket.objects["#{ENV['VONAGE_API_KEY']}/#{@video.archive_id}/archive.mp4"].write(file, content_type: "video/mp4")
      File.delete(file)
    end
  end
end
