require 'i18n'
require 'rack/test'
require 'action_controller/railtie'

$LOAD_PATH.unshift(File.expand_path('../../../../lib', __FILE__))
require 'route_translator'

module Dummy
  class Application < Rails::Application
    # config.logger = Logger.new(File.new("/dev/null", 'w'))
    config.active_support.deprecation = :log
    config.eager_load = false
  end
end
