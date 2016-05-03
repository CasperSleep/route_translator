module RouteTranslator
  class DeferredRouteSet < ActionDispatch::Routing::RouteSet
    def draw
      if block_given?
        append(&Proc.new)
      else
        super {}
      end
    end
  end
end

module ActionDispatch
  module Routing
    class Mapper
      module Base
        alias original_mount mount
        def mount(app, options = nil)
          original_mount(app, options)
          if app.respond_to?(:routes) && app.routes.is_a?(RouteTranslator::DeferredRouteSet)
            app.routes.draw
          end
          self
        end
      end
    end
  end
end

module Rails
  class Engine
    alias original_routes routes
    def routes
      if is_a? Rails::Application
        original_routes
      else
        @routes ||= RouteTranslator::DeferredRouteSet.new
        @routes.exclude_locale = true
        @routes.append(&Proc.new) if block_given?
        @routes
      end
    end
  end
end
