# Be sure to restart your server when you modify this file.
 domain = case Rails.env
          when :development
            '.lvh.me'
          when :production
            '.connectedcity.com'
          when :staging
            '.'
          end

Connectbook::Application.config.session_store :cookie_store, key:    '_connectbook_session', domain: domain

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Connectbook::Application.config.session_store :active_record_store
