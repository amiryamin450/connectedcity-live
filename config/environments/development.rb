Connectbook::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false


  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true


  # ActionMailer Config
  config.action_mailer.delivery_method = :smtp
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = true

  # config.action_mailer.delivery_method = :sendmail
  # config.action_mailer.smtp_settings = {
  #   :address => "email-smtp.us-west-1.amazonaws.com",
  #   :port => 587,
  #   :user_name => ENV['SES_SMTP_USERNAME'], #Your SMTP user
  #   :password => ENV['SES_SMTP_PASSWORD'], #Your SMTP password
  #   :authentication => :login,
  #   :enable_starttls_auto => true
  # }

  # Config for Mailgun service
  config.action_mailer.smtp_settings = {
    authentication: :plain,
    address: "smtp.mailgun.org",
    port: 587,
    domain: ENV['MAILGUN_DOMAIN'],
    user_name: ENV['MAILGUN_USERNAME'],
    password: ENV['MAILGUN_PASSWORD']
  }

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  config.log_level = :debug
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger::DEBUG

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Expands the lines which load the assets
  config.assets.debug = false


  config.to_prepare do
    Devise::SessionsController.layout "application_v_2"
  end

  Paperclip.options[:command_path] = '/usr/local/bin/'

  config.paperclip_defaults = {
    storage: :s3,
    url: ":s3_domain_url",
    path: "/system/:class/:id.:style.:extension",
    s3_host_name: "s3.#{ENV['AWS_REGION']}.amazonaws.com",
    s3_protocol: "https",
    s3_credentials: {
      bucket: ENV['S3_BUCKET_NAME'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      s3_region: ENV['AWS_REGION'],
    }
  }

  config.eager_load = false

end
#Tire::Configuration.url "http://10.10.0.55:9200"