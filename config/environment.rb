# Load the Rails application.
require_relative 'application'
# require File.expand_path('../application', __FILE__)

# Initialize the rails application
Connectbook::Application.initialize!

require File.expand_path('../../lib/patches/mysql2_adapter', __FILE__)

CLASSIFIED_CONDITION_OPTIONS = {'New' => 5, 'Refurbished' => 4, 'Used - Like New' => 3, 'Used - Very Good' => 2, 'Used - Good' => 1, 'Used - Acceptable' => 0}
