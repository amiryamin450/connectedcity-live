# Redirects requests for any other host name (the app's herokuapp.com address,
# leftover custom domains) to the real domain. Crawlers that find the Heroku
# address would otherwise reach the app directly and skip Cloudflare's bot rules.
#
# Off unless CANONICAL_HOST is set, so the herokuapp.com address still works for
# testing. Only GET and HEAD are redirected; webhooks and form posts pass through.
class CanonicalHost
  def initialize(app, host)
    @app = app
    @host = host
    @allowed_hosts = [host, "www.#{host}"]
  end

  def call(env)
    request = Rack::Request.new(env)
    return @app.call(env) if @allowed_hosts.include?(request.host) || !(request.get? || request.head?)

    [301, { 'Location' => "https://#{@host}#{request.fullpath}", 'Content-Type' => 'text/plain' }, ["Moved to https://#{@host}"]]
  end
end

if ENV['CANONICAL_HOST'].present?
  Rails.application.config.middleware.insert_before 0, CanonicalHost, ENV['CANONICAL_HOST']
end
