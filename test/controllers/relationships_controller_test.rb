require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:one)
  end
  test "should create relationship" do

    sign_in @user

    assert_difference('Relationship.count') do

      post :create, relationship: { followed_id: User.last}
    end
    assert_redirected_to user_path(User.last)
  end
  test "should fail create relationship" do

    assert_no_difference('Relationship.count') do

      post :create, relationship: { followed_id: User.last}

    end
    assert_redirected_to signin_path
  end
  test "should delete destroy" do

    sign_in @user

    assert_difference('Relationship.count', -1) do

      delete :destroy, id: @user.relationships.first

    end
    assert_redirected_to user_path(2)
  end
  test "should fail delete destroy" do

    assert_no_difference('Relationship.count') do

      delete :destroy, id: @user.relationships.first
    end
    assert_redirected_to signin_path
  end
end
