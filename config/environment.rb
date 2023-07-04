# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :address => 'SSL0.OVH.NET',
  :port => 587,
  :user_name => Rails.application.credentials.dig(:ovh, :access_key_id),
  :password => Rails.application.credentials.dig(:ovh, :secret_access_key),
  :authentication => :login,
  :enable_starttls_auto => true
}

# ActionMailer::Base.smtp_settings = {
#   :address => 'SSL0.OVH.NET',
#   :port => 587,
#   :user_name => ENV['APP_KEY'],
#   :password => ENV['APP_SECRET'],
#   :authentication => :login,
#   :enable_starttls_auto => true
# }