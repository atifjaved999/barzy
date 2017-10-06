require 'test_helper'

class Admin::ProductCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_product_category = admin_product_categories(:one)
  end

  test "should get index" do
    get admin_product_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_product_category_url
    assert_response :success
  end

  test "should create admin_product_category" do
    assert_difference('Admin::ProductCategory.count') do
      post admin_product_categories_url, params: { admin_product_category: {  } }
    end

    assert_redirected_to admin_product_category_url(Admin::ProductCategory.last)
  end

  test "should show admin_product_category" do
    get admin_product_category_url(@admin_product_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_product_category_url(@admin_product_category)
    assert_response :success
  end

  test "should update admin_product_category" do
    patch admin_product_category_url(@admin_product_category), params: { admin_product_category: {  } }
    assert_redirected_to admin_product_category_url(@admin_product_category)
  end

  test "should destroy admin_product_category" do
    assert_difference('Admin::ProductCategory.count', -1) do
      delete admin_product_category_url(@admin_product_category)
    end

    assert_redirected_to admin_product_categories_url
  end
end
