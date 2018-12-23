require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "masato", email: "masatonnoguchi@gmail.com",
                         password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "john", email: "john@gmail.com",
                         password: "password", password_confirmation: "password")
    @admin_chef = Chef.create!(chefname: "admin", email: "admin@gmail.com",
                         password: "password", password_confirmation: "password", admin: true)

    @recipe = Recipe.create(name: "vegetable saute", description: "great vegetable sautee, add vegetable and oil", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken saute", description: "great chicken dish")
    @recipe2.save
  end
  
  test "should get chefs show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.chefname, response.body
  end
  
  test "should get chefs index" do
    get chef_path(@chef)
    assert_response :success
  end

  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.chefname.capitalize
  end
  
  test "should delete chef" do
    sign_in_as(@admin_chef, "password")
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
  
end
