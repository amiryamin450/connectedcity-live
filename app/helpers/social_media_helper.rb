module SocialMediaHelper
  def render_social_media_buttons(status_update)
  	  status_update_url		= status_update[:url].html_safe
  	  status_update_title 	= html_escape(status_update[:title]) + " - ConnectedCity"
  	  status_update_content = html_escape(status_update[:content])
  	  status_update_image 	= status_update[:image] || ""

      "<div class=\"addthis_native_toolbox\" style=\"float: right;\" data-url=\"#{status_update_url}\" data-title=\"#{status_update_title}\" data-description=\"#{status_update_content}\" data-image=\"#{status_update_image}\"></div>".html_safe
  end
end
