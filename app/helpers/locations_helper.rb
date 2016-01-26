module LocationsHelper

  def display_phone(check_field, display_field, label)
    content_tag(:div, content_tag(:strong, "#{label}: ") + @location.send(display_field)) if @location.send(check_field) and @location.send(display_field).present?
  end

  def display_profile_field(field, label)
    content_tag(:div, content_tag(:strong, "#{label}: ") + @location.send(field)) if @location.send(field).present?
  end

  def show_save_button? user_signed_in, vertical_markets_present
  	vertical_markets_present unless !vertical_markets_present
  end
end
