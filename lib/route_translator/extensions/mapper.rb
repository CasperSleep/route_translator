# frozen_string_literal: true
require 'action_dispatch'

module ActionDispatch
  module Routing
    class Mapper
      def localized
        Thread.current[:localized] = true
        yield
        Thread.current[:localized] = false
      end

      def add_route(action, options) # :nodoc:
        path = path_for_action(action, options.delete(:path))

        if action.to_s =~ %r{^[\w\/]+$}
          options[:action] ||= action unless action.to_s.include?('/'.freeze)
        else
          action = nil
        end

        if !options.fetch(:as, true)
          options.delete(:as)
        else
          options[:as] = name_for_action(options[:as], action)
        end

        mapping = begin
                    Mapping.new(@set, @scope, path, options)
                  rescue ArgumentError
                    Mapping.build(@scope, @set, URI.parser.escape(path), options.delete(:as), options)
                  end

        if Thread.current[:localized]
          @set.add_localized_route(*mapping.to_route)
        else
          @set.add_route(*mapping.to_route)
        end
      end
    end
  end
end
