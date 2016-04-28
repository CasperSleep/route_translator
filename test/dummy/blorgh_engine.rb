module Blorgh
  class Engine < ::Rails::Engine
    isolate_namespace Blorgh

    routes.draw do
      get 'show',   to: 'posts#show'
      get 'search', to: 'posts#search'
    end
  end

  class PostsController < ActionController::Base
    def show
      render inline: %(<link_to "Show [#{I18n.locale}]", show_path %>)
    end

    def search
      render inline: %(<%= link_to "Search [#{I18n.locale}]", search_path %>)
    end
  end
end
