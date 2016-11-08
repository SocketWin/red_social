require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:post_1)
    @user = users(:user_1)
  end

  # test "usuario crea post" do
  #   sign_in @user
  #   assert_difference('Post.count') do
  #     post :create, post: { comment: @post.comment }
  #   end
  #   assert_redirected_to root_path
  # end
  test "anonimo no puede crear post" do
    assert_no_difference('Post.count') do
      post :create, post: { comment: @post.comment, user_id: 1 }
    end
    assert_redirected_to signin_path
  end
  # test "usuario borra sus posts" do
  #   sign_in @user
  #   post_mio = @user.posts.create(comment: "comentario")
  #   assert_difference('Post.count', -1) do
  #     delete :destroy, id: post_mio
  #   end
  #   assert_redirected_to root_path
  # end
  # test "usuario no puede borrar posts ajenos" do
  #   sign_in @user
  #   delete :destroy, id: @post
  #   assert_redirected_to root_path
  # end
  test "anonimo no puede borrar posts" do
    delete :destroy, id: @post
    assert_redirected_to signin_path
  end

end
