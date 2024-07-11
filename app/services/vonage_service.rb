class VonageService
  API_KEY = ENV["VONAGE_API_KEY"]
  SECRET_KEY = ENV['VONAGE_SECRET_KEY']
  API_KEY_2FA = ENV["VONAGE_2FA_API_KEY"]
  SECRET_KEY_2FA = ENV['VONAGE_2FA_SECRET_KEY']

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

  def generate_broadcast_token session_id
    token = opentok.generate_token(session_id, role: :publisher)
  end

  def start_broadcast params
    opts = {
      :maxDuration => params[:max_duration],
      :resolution =>  params[:resolution],
      # :layout => params[:layout],
      :outputs => {
        :hls => {}
      }
    }

    broadcast = opentok.broadcasts.create(params[:session_id], opts)
  end

  def stop_broadcast broadcast_id
    broadcast = opentok.broadcasts.stop broadcast_id
  end

  def create_archive params
    begin
      archive = opentok.archives.create params[:session_id], {
        :name => params[:media_attachment][:title],
        :output_mode => :composed,
        :has_audio => true,
        :has_video => true,
        :resolution => "1920x1080"
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

  def create_thumbnail media_attachment, video_url
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

  def self.verify_2fa(user)
    client = Vonage::Client.new(
      api_key: API_KEY_2FA,
      api_secret: SECRET_KEY_2FA
    )

    if user.verifying_request_id.present?
      client.verify.cancel(user.verifying_request_id) rescue nil
      user.verifying_request_id = nil
      user.save!
    end

    response = client.verify.request(
      number: user.phone_number,
      brand: 'ConnectedCity'
    )

    if response
      user.verifying_request_id = response.request_id
      user.save!
    end
  end

  def self.verify_2fa_otp(user, code)
    client = Vonage::Client.new(
      api_key: API_KEY_2FA,
      api_secret: SECRET_KEY_2FA
    )

    response = client.verify.check(
      request_id: user.verifying_request_id,
      code: code
    ) rescue nil

    if response
      user.verifying_request_id = nil
      user.save!
      true
    else
      false
    end
  end
end
