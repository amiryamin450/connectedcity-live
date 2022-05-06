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

  def check_video_url
    @video = Video.find_by_id(params[:video_id])
    if @video.present?
      videos = @video.media_attachment.videos
      if @video.video_url.present? && videos.size > 1
        file_list = []
        videos.each do |v|
          cmd = "ffmpeg -i '#{v.video_url}' -c copy -bsf:v h264_mp4toannexb -f mpegts #{Rails.root}/public/#{v.id}.ts"
          system( cmd )
          file_list << "#{Rails.root}/public/#{v.id}.ts"
        end
        cmd = "ffmpeg -i 'concat:#{file_list.join('|')}' -c copy #{Rails.root}/public/archive.mp4"
        system( cmd )
        upload_video_to_s3
        file_list.each do |file|
          file = File.open(file)
          File.delete(file)
        end
      end
      render json: {generated_url: @video.video_url.present?}, status: :ok
    end
  end

  def show
    @video = Video.find_by_id(params[:id])
  end

  def destroy
    video = Video.find_by_id(params[:id])
    media_attachment = video.media_attachment
    location = media_attachment.location
    media_attachment.destroy

    redirect_to new_location_media_attachment_url(location)
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
