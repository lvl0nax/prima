# -*- encoding : utf-8 -*-
require 'test_helper'

class SubordersControllerTest < ActionController::TestCase
  setup do
    @suborder = suborders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:suborders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create suborder" do
    assert_difference('Suborder.count') do
      post :create, :suborder => @suborder.attributes
    end

    assert_redirected_to suborder_path(assigns(:suborder))
  end

  test "should show suborder" do
    get :show, :id => @suborder.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @suborder.to_param
    assert_response :success
  end

  test "should update suborder" do
    put :update, :id => @suborder.to_param, :suborder => @suborder.attributes
    assert_redirected_to suborder_path(assigns(:suborder))
  end

  test "should destroy suborder" do
    assert_difference('Suborder.count', -1) do
      delete :destroy, :id => @suborder.to_param
    end

    assert_redirected_to suborders_path
  end
end
