# coding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class EngineTest < integration_test_suite_parent_class
  include RouteTranslator::ConfigurationHelper

  def test_path_generated
    get '/blorgh/search'
    assert_response :success
    assert_tag tag: 'a', attributes: { href: '/blorgh/search' }
  end

  def test_path_translated
    get '/es/blorgh/buscar'
    assert_response :success
    assert_tag tag: 'a', attributes: { href: '/es/blorgh/buscar' }
  end

  def test_path_translated_after_force
    config_force_locale true

    get '/es/blorgh/buscar'
    assert_response :success
    assert_tag tag: 'a', attributes: { href: '/es/blorgh/buscar' }
  end

  def test_path_translated_while_generate_unlocalized_routes
    config_default_locale_settings 'en'
    config_generate_unlocalized_routes true

    get '/es/blorgh/buscar'
    assert_response :success
    assert_tag tag: 'a', attributes: { href: '/es/blorgh/buscar' }
  end

  def test_engine_path_helper
    assert_equal '/blorgh/search', blorgh.search_path
  end

  def test_engine_path_helper_translated
    I18n.with_locale(:es) do
      assert_equal '/es/blorgh/buscar', blorgh.search_path
    end
  end
end
