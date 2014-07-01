module LocationsHelper

  def display_phone(check_field, display_field, label)
    content_tag(:div, content_tag(:strong, "#{label}: ") + @location.send(display_field)) if @location.send(check_field) and @location.send(display_field).present?
  end

  def display_profile_field(field, label)
    content_tag(:div, content_tag(:strong, "#{label}: ") + @location.send(field)) if @location.send(field).present?
  end





end
