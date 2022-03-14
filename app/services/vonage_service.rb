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
    archive = opentok.archives.create params[:session_id], {
      :name => params[:video_name],
      :output_mode => "composed",
      :has_audio => params[:has_audio] == "on",
      :has_video => params[:has_video] == "on"
    }
    archive
  end

  def stop_archive params
    archive = opentok.archives.stop_by_id(params[:archive_id])
    archive
  end
end