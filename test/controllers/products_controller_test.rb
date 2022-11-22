# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index,' do
    get products_index, _url
    assert_response :success
  end

  test 'should get show,' do
    get products_show, _url
    assert_response :success
  end

  test 'should get create,' do
    get products_create, _url
    assert_response :success
  end

  test 'should get update,' do
    get products_update, _url
    assert_response :success
  end

  test 'should get delete' do
    get products_delete_url
    assert_response :success
  end
end
