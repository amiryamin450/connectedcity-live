module LocationsHelper

  def display_phone(check_field, display_field, label, location)
    content_tag(:div, content_tag(:strong, "#{label}: ") + location.send(display_field)) if location.send(check_field) and location.send(display_field).present?
  end

  def display_profile_field(field, label)
    content_tag(:div, content_tag(:strong, "#{label}: ") + @location.send(field)) if @location.send(field).present?
  end

  def show_save_button?(user_signed_in, vertical_markets_present)
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

  def show_message_button?(user_signed_in)
    user_signed_in
  end

  def show_claim_button?(user_signed_in, location)
    unless location.claim_pending or location.user_ids.present?
      return true if user_signed_in
    end

    false
  end

  def show_release_business_button?(user_signed_in, current_user, location)
    true if location.user_ids.any? and user_signed_in and location.user_ids.include?(current_user.id) && location.claim_pending?
  end

  def show_claim_pending?(user_signed_in, current_user, location)
    true if user_signed_in and location.user_ids.any? and location.user_ids.include?(current_user.id) && location.claim_pending?
  end

  def render_message_button(user_signed_in, location)
    link_to "Send a message", "#", class: "btn btn-mini btn-success btn-message", role: "button", data: { toggle: "modal", target: "#new_message", location: location } if show_message_button?(user_signed_in)
  end

  def render_login_popup
    link_to(image_tag("button_follow.jpg", class: "follow_button_image"), "#", role: "button", data: { toggle: "modal", target: "#login_for_save" })
  end

  def render_claim_button_for_modal
    link_to "Claim Business", "#", class: 'btn btn-mini btn-success btn-claim-business', role: "button", data: { toggle: "modal", target: "#claim_login" }
  end

  def render_claim_pending(user_signed_in, current_user, location)
    return '<span class="btn btn-mini btn-info">Claim Pending</span>
    <div class="processing-claim">
      We have recieved your claim and are processing it.
    </div>' if show_claim_pending?(user_signed_in, current_user, location)
  end
end
