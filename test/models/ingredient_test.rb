require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  
  def setup
    @ingredient = Ingredient.create!(name: "chicken")
  end
  
  test "ingredient should be valid" do
    assert @ingredient.valid?
  end

  test "name should be present" do
    @ingredient.name = " "
    assert_not @ingredient.valid?
  end

  test "name should be longer than 3" do
    @ingredient.name = "abc"
    assert @ingredient.valid?
  end

  test "name should be shorter than 25" do
    @ingredient.name = "12345678901234567890123456"
    assert_not @ingredient.valid?
  end

  test "name is valid when length is 25" do
    @ingredient.name = "1234567890123456789012345"
    assert @ingredient.valid?
  end

  test "duplicate name is invalid" do
    @ingredient2 = Ingredient.create(name: "chicken")
    @ingredient2.save
    assert_not @ingredient2.valid?
  end

end