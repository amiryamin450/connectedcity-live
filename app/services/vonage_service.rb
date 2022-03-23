class VonageService
  API_KEY = ENV["VONAGE_API_KEY"]
  SECRET_KEY = ENV['VONAGE_SECRET_KEY']

  def opentok
    opentok = OpenTok::OpenTok.new API_KEY, SECRET_KEY
  end

  def get_session_id
    session = opentok.create_session :media_mode => :routed
    session_id = session.session_id
  end

  def get_token session_id
    token = opentok.generate_token(session_id, :role => :moderator)
  end

  def create_archive params
    begin
      archive = opentok.archives.create params[:session_id], {
        :name => params[:media_attachment][:title],
        :output_mode => :composed,
        :has_audio => true,
        :has_video => true,
        :resolution => "1280x720"
      }
      archive
    rescue => e
      puts e
    end
  end

  def stop_archive params
    archive = opentok.archives.stop_by_id(params[:archive_id])
  end

  def get_archive archive_id
    opentok.archives.find archive_id
  end

  def create_thumbnail archive_id
    video_url = get_archive(archive_id)&.url
    media_attachment = MediaAttachment.find_by_archive_id(archive_id)

    if video_url.present? && media_attachment.present?
      cmd = "ffmpeg -i '#{video_url}' -ss 00:00:1 -frames:v 1 #{Rails.root}/public/thumbnail.png"
      system( cmd )
      file = File.open("#{Rails.root}/public/thumbnail.png")
      if file.present?
        media_attachment.stream_thumbnail = file
        file.close
        File.delete(file)
        media_attachment.save
      end
    end
  end
end
