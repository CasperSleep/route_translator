require 'action_dispatch'

module ActionDispatch
  module Routing
    class RouteSet
      attr_accessor :exclude_locale

      def add_localized_route(app, conditions = {}, requirements = {}, defaults = {}, as = nil, anchor = true)
        RouteTranslator::Translator.translations_for(app, conditions, requirements, defaults, as, anchor, self) do |*translated_args|
          add_route(*translated_args)
        end

        if RouteTranslator.config.generate_unnamed_unlocalized_routes
          add_route app, conditions, requirements, defaults, nil, anchor
        elsif RouteTranslator.config.generate_unlocalized_routes
          add_route app, conditions, requirements, defaults, as, anchor
        end
      end

      class NamedRouteCollection
        alias original_get get
        def get(name)
          name_with_current_locale = "#{name}_#{I18n.locale.to_s.underscore}"
          name_with_default_locale = "#{name}_#{I18n.default_locale.to_s.underscore}"

          original_get(name) || original_get(name_with_current_locale) || original_get(name_with_default_locale)
        end
      end
    end
  end
end
