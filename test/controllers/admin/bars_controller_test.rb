require 'test_helper'

class Admin::BarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_bar = admin_bars(:one)
  end

  test "should get index" do
    get admin_bars_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_bar_url
    assert_response :success
  end

  test "should create admin_bar" do
    assert_difference('Admin::Bar.count') do
      post admin_bars_url, params: { admin_bar: {  } }
    end

    assert_redirected_to admin_bar_url(Admin::Bar.last)
  end

  test "should show admin_bar" do
    get admin_bar_url(@admin_bar)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_bar_url(@admin_bar)
    assert_response :success
  end

  test "should update admin_bar" do
    patch admin_bar_url(@admin_bar), params: { admin_bar: {  } }
    assert_redirected_to admin_bar_url(@admin_bar)
  end

  test "should destroy admin_bar" do
    assert_difference('Admin::Bar.count', -1) do
      delete admin_bar_url(@admin_bar)
    end

    assert_redirected_to admin_bars_url
  end
end
