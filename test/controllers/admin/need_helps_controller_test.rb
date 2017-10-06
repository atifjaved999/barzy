require 'test_helper'

class Admin::NeedHelpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_need_help = admin_need_helps(:one)
  end

  test "should get index" do
    get admin_need_helps_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_need_help_url
    assert_response :success
  end

  test "should create admin_need_help" do
    assert_difference('Admin::NeedHelp.count') do
      post admin_need_helps_url, params: { admin_need_help: {  } }
    end

    assert_redirected_to admin_need_help_url(Admin::NeedHelp.last)
  end

  test "should show admin_need_help" do
    get admin_need_help_url(@admin_need_help)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_need_help_url(@admin_need_help)
    assert_response :success
  end

  test "should update admin_need_help" do
    patch admin_need_help_url(@admin_need_help), params: { admin_need_help: {  } }
    assert_redirected_to admin_need_help_url(@admin_need_help)
  end

  test "should destroy admin_need_help" do
    assert_difference('Admin::NeedHelp.count', -1) do
      delete admin_need_help_url(@admin_need_help)
    end

    assert_redirected_to admin_need_helps_url
  end
end
