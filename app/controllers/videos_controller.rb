class VideosController < ApplicationController

  def update
    @video = Video.find_by_id(params[:id])
    media_attachment = @video.media_attachment

    if media_attachment_params.present?
      media_attachment.update(media_attachment_params)
      media_attachment.reload.update_attribute(:is_draft, false)
    end

    location = media_attachment.location
    redirect_to location_media_attachments_url(location)
  end

  def mute_video_audio
    @video = Video.find_by_id(params[:video_id])
    cmd = "ffmpeg -i '#{@video.video_url}' -c copy -an #{Rails.root}/public/archive.mp4"
    system( cmd )
    upload_video_to_s3
    head :ok
  end

  def upload_audio
    @video = Video.find_by_id(params[:video_id])
    cmd = "ffmpeg -i '#{@video.video_url}' -i '#{params[:file].path}' -map 0:v -map 1:a -c:v copy -shortest #{Rails.root}/public/archive.mp4"
    system( cmd )
    upload_video_to_s3

    head :ok
  end

  def upload_thumbnail
    @video = Video.find_by_id(params[:video_id])
    @video.thumbnail = params[:file]
    @video.save

    head :ok
  end

  def update_media_attachment
    video = Video.find_by_id(params[:video_id])
    media_attachment = video.media_attachment
    media_attachment.update(JSON.parse(params[:media_attachment]))
    head :ok
  end

  def check_video_url
    @video = Video.find_by_id(params[:video_id])
    if @video.present?
      media_attachment = @video.media_attachment
      videos = @video.media_attachment.videos
      if @video.video_url.present?
        if videos.size > 1
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

        media_attachment = @video.media_attachment
        video = media_attachment.videos.first
        unless video.thumbnail.file?
          cmd = "ffmpeg -i '#{video.video_url}' -ss 00:00:1 -frames:v 1 #{Rails.root}/public/thumbnail.png"
          system( cmd )
          file = File.open("#{Rails.root}/public/thumbnail.png")
          if file.present?
            video.thumbnail = file
            file.close
            File.delete(file)
            video.save
          end
        end
      end
      render json: {generated_url: @video.video_url.present?}, status: :ok
    end
  end

  def show
    @video = Video.find_by_id(params[:id])

    render layout: 'application_v_2'
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

  def media_attachment_params
    params.require(:video).permit(:media_attachment_attributes)
  end
end
