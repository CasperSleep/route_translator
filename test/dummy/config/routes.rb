require File.join(Dummy::Application.root, 'dummy_mounted_app.rb')
require File.join(Dummy::Application.root, 'blorgh_engine.rb')

Dummy::Application.routes.draw do
  localized do
    get 'dummy',  to: 'dummy#dummy'
    get 'show',   to: 'dummy#show'

    get 'optional(/:page)', to: 'dummy#optional', as: :optional
    get 'prefixed_optional(/p-:page)', to: 'dummy#prefixed_optional', as: :prefixed_optional

    get ':id-suffix', to: 'dummy#suffix'

    mount Blorgh::Engine, at: '/blorgh'
  end

  get 'partial_caching', to: 'dummy#partial_caching'
  get 'native', to: 'dummy#native'
  root to: 'dummy#dummy'

  mount DummyMountedApp.new => '/dummy_mounted_app'
end
