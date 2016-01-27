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

  def show_edit_button?(user_signed_in, current_user, location = nil)
    if user_signed_in and current_user.has_role? :admin
      true
    elsif user_signed_in and location and current_user.can_manage_location? location
      true
    else
      false
    end
  end
end
