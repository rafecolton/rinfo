# coding: utf-8

require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rinfo'
require 'action_controller'

class Rinfo
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.time_zone = 'Pacific Time (US & Canada)'
  end
end
