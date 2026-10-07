# The necessary methods your controller needs to use prismic.io transparently
module PrismicController

  private

  def redirect_to_signin
    redirect_to signin_path
  end

  # Setting @ref as the actual ref id being queried, even if it's the master ref.
  # To be used to call the API, for instance: api.form('everything').submit(ref)
  def ref
    @ref ||= maybe_ref || api.master_ref.ref
  end

  # Setting @maybe_ref as the ref id being queried, or nil if it is the master ref.
  # To be used where you want nothing if on master, but something if on another release.
  # For instance:
  #  * you can use it to call Rails routes: document_path(ref: maybe_ref), which will add "?ref=refid" as a param, but only when needed.
  #  * you can pass it to your link_resolver method, which will use it accordingly.
  def maybe_ref
    @maybe_ref ||= (params[:ref].blank? ? nil : params[:ref])
  end

  ##

  # Slide images for a landing page, from the Prismic document with this uid.
  # The slideshow is decorative: if Prismic fails (outage, revoked access, timeout),
  # render the page without it instead of failing the whole request.
  def prismic_slide_images(uid)
    response = api.query(Prismic::Predicates.at("my.location.uid", uid))
    response.results.present? ? response.results[0]["location.slide_images"] : []
  # Prismic::Error inherits from Exception, not StandardError, so it must be named explicitly.
  rescue Prismic::Error, StandardError => e
    Rails.logger.warn("[prismic] slide images unavailable for #{uid.inspect}: #{e.class}: #{e.message.to_s[0, 200]}")
    []
  end

  # Easier access and initialization of the Prismic::API object.
  def api
    @api ||= PrismicService.init_api(access_token)
  rescue Prismic::API::PrismicWSAuthError => e
    reset_access_token!
    raise e
  end

  def access_token
    @access_token = session['ACCESS_TOKEN']
  end

  def reset_access_token!
    @access_token = session['ACCESS_TOKEN'] = nil
  end

end
