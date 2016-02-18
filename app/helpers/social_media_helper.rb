module SocialMediaHelper
  def get_social_url(type)
    if type == :status_update
      "http://localhost:3000/business/don-s-computers"
    end
  end
end
