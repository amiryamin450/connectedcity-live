class VideoCallsController < ActionController::Base

  def get_vonage_token
    session_id = vonage.get_session_id
    token = vonage.get_token(session_id)
    @location = Location.find(params[:location_id])
    users = @location.users.where("users.id != ?", current_user.id)
    if users.present?
      users.each  do|user|
          video_call = VideoCall.find_by_user_business_id_and_user_call_id(user.id, current_user.id)
          if video_call.present? 
            video_call.update_attributes(session_id: session_id, status: "request_calling", token: token, location_id: @location.id)
          else
            VideoCall.create(user_business_id: user.id, user_call_id: current_user.id, session_id: session_id, status: "request_calling", token: token, location_id: @location.id)
          end
        end
    end
    render json: { session_id: session_id, token: token }
  end

  def call_request 
    video_calls = VideoCall.where(user_business_id: params[:user_id], status: "request_calling")
    list_call = []
    if video_calls.present?
      # token vonage.generate_broadcast_token(params[:session_id])
      video_calls.each do |vd| 
        full_name = User.find(vd.user_call_id).first_name + " "+ User.find(vd.user_call_id).last_name
        list_call << {session_id: vd.session_id, status: vd.status, user_call_id: vd.user_call_id, user_name: full_name, token: vd.token}
      end
      render json:{ list_user_call: list_call }
    else
      render json:{ list_user_call: list_call }
    end
    
  end

  def get_status_from_session
    status = []
    video_calls = VideoCall.where(session_id: params[:session_id])
    if video_calls.present?
      status = video_calls.pluck(:status)
    end
    render json:{status: status}
  end
  
  def set_status_call
    if params[:session_id].present?
      VideoCall.where(session_id: params[:session_id]).update_all(status: params[:status])
    elsif params[:accept]
      video_call = VideoCall.find_by_user_business_id_and_user_call_id(params[:user_business_id], params[:user_call_id])
      video_call.update_attribute(:status,params[:status])
      session_id = video_call.session_id
      VideoCall.where(session_id: session_id).where("video_calls.id != ?",video_call.id).update_all(status: "available")
    else
      video_call = VideoCall.find_by_user_business_id_and_user_call_id(params[:user_business_id], params[:user_call_id])
      video_call.update_attribute(:status,params[:status])
    end
   
    render json:{}
  end

  def get_status_from_location
    video_calls = VideoCall.where(location_id: params[:location_id])
    if video_calls.present?
      if video_calls.pluck(:status).include?("accept_call")
        return render json: {available_call: false}
      elsif video_calls.pluck(:status).include?("request_calling")
        return render json: {available_call: false}
      else
        return render json: {available_call: true}
      end
    end
    render json:{available_call: true}
  end

  def vonage
    @vonage ||= VonageService.new
  end

end