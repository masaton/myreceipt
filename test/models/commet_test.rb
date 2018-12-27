require 'test_helper'

class ComentTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.create!(chefname: "masato", email: "masatonoguchi@gmail.com",
                          password: "password", password_confirmation: "password")
    @recipe = Recipe.create!(chef_id: @chef.id, name: "vegetable", description: "great vegetable recipe")
    @comment = Comment.create!(description: "great!", chef_id: @chef.id, recipe_id: @recipe.id)
  end
  
  test "should be valid" do
    assert @comment.valid?
  end
  
  test "description should be present" do
    @comment.description = " "
    assert_not @comment.valid?
  end

  test "description should be longer than 4 characters" do
    @comment.description = "a" * 3
    assert_not @comment.valid?
  end

  test "description should be less than 140 characters" do
    @comment.description = "a" * 141
    assert_not @comment.valid?
  end

  test "description is minimum length" do
    @comment.description = "a" * 4
    assert @comment.valid?
  end

  test "description is maximum length" do
    @comment.description = "a" * 140
    assert @comment.valid?
  end

  test "sort order is descending of updated_at" do
    @comment2 = Comment.create!(description: "after!", chef_id: @chef.id, recipe_id: @recipe.id)
    @comments = Comment.all
    @comments.each_with_index do |comment, index|
      if index == 0
        assert_equal comment.description, "after!" 
      elsif index == 1
        assert_equal comment.description, "great!"
      end
    end
  end
  
end