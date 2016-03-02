module SocialMediaHelper
  def render_social_media_buttons(status_update)
      "<div class=\"addthis_native_toolbox\" style=\"float: right;\" data-url=\"#{status_update[:url]}\" data-title=\"#{status_update[:title]}\" data-description=\"#{status_update[:content]}\"></div>".html_safe
  end
end
