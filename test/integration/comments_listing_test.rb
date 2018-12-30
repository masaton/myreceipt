require 'test_helper'

class CommentsListingTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = Chef.create!(chefname: "admin", email: "admin@gmail.com", password: "password", password_confirmation: "password", admin: true)
    @recipe = Recipe.create!(name: "beef noodle", description: "boil, cut, soy sauce", chef_id: @admin.id)
    @comment = Comment.create!(description: "first", recipe_id: @recipe.id, chef_id: @admin.id)
  end
    
  test "should get comments listing" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @comment.description, response.body
  end

  test "should be textarea for comment" do
    sign_in_as(@admin, "password")
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select "textarea", id: "comment_description"
  end

  test "should not be textarea for comment" do
#     sign_in_as(@admin, "password")
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select "textarea", { count: 0, id: "comment_description"}
  end

#   test "should be detail and edit link" do
#     sign_in_as(@admin, "password")
#     get ingredients_path
#     assert_template 'ingredients/index'
#     assert_select "a[href=?]", ingredient_path(@ingredient), @ingredient.name.capitalize
#     assert_select "a[href=?]", edit_ingredient_path(@ingredient), "Edit this ingredient"
#   end

#   test "should not be edit link" do
#     sign_in_as(@normal, "password")
#     get ingredient_path(@ingredient)
#     assert_template 'ingredients/show'
#     assert_select "a", {count: 0, text: "Edit this ingredient"}
#   end

#   test "should get ingredient show" do
#     sign_in_as(@admin, "password")
#     get ingredient_path(@ingredient)
#     assert_template 'ingredients/show'
#     assert_select "h4", { text: "No recipes yet!"}
#   end

#   test "should get ingredient show when there is recipe" do
#     sign_in_as(@admin, "password")
#     @recipe.ingredients << @ingredient
#     get ingredient_path(@ingredient)
#     assert_template 'ingredients/show'
#     assert_select "a[href=?]", recipe_path(@recipe), @recipe.name
#   end    
end
