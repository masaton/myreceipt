require 'test_helper'

class IngredientsEditTest < ActionDispatch::IntegrationTest

  def setup
    @ingredient = Ingredient.create!(name: "potato")
    @admin = Chef.create!(chefname: "admin", email: "admin@gmail.com",
                        password: "password", password_confirmation: "password", admin: true)
    @normal = Chef.create!(chefname: "john", email: "john@gmail.com",
                           password: "password", password_confirmation: "password")
  end
  
  test "accept valid edit by admin" do
    sign_in_as(@admin, "password")
    get edit_ingredient_path(@ingredient)
    assert_template 'ingredients/edit'
    patch ingredient_path(@ingredient), params: { ingredient: { name: "beef"} }
    assert_redirected_to @ingredient
    assert_not flash.empty?
    @ingredient.reload
    assert_match "beef", @ingredient.name
  end

  test "rejected edit attempt by another non-admin user" do
    sign_in_as(@normal, "password")
    get edit_ingredient_path(@ingredient)
    assert_redirected_to ingredients_path
    assert_not flash.empty?
  end

  test "rejected edit attempt by not logged in" do
    get edit_ingredient_path(@ingredient)
    assert_redirected_to ingredients_path
    assert_not flash.empty?
  end

  test "reject invalid edit by non-admin" do
    sign_in_as(@normal, "password")
    patch ingredient_path(@ingredient), params: { ingredient: { name: "beef"} }
    assert_redirected_to ingredients_path
    assert_not flash.empty?
    @ingredient.reload
    assert_match "potato", @ingredient.name
  end

  test "reject invalid edit by not logged in" do
    patch ingredient_path(@ingredient), params: { ingredient: { name: "beef"} }
    assert_redirected_to ingredients_path
    assert_not flash.empty?
    @ingredient.reload
    assert_match "potato", @ingredient.name
  end  
end
