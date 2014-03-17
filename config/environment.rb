# Load the rails application.
require File.expand_path('../application', __FILE__)

# Initialize the rails application.
#Setting.load(:path  => "#{Rails.root}/config/settings",
             #:files => ["default.yml", "environments/#{Rails.env}.yml"],
             #:local => true)

RinfoApp::Application.initialize!
