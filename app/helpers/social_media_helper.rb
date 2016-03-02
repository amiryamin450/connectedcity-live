module SocialMediaHelper
  def render_social_media_buttons(status_update)
  	  status_update_url		= status_update[:url].html_safe
  	  status_update_title 	= status_update[:title].html_safe
  	  status_update_content = status_update[:content].html_safe

      "<div class=\"addthis_native_toolbox\" style=\"float: right;\" data-url=\"#{status_update_url}\" data-title=\"#{status_update_title}\"></div>".html_safe
  end
end
