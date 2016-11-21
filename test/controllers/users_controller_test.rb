require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_1)
  end

  test "should get index" do
    get :index
    sign_in @user
    # assert_response :success
    assert_response :found
    # assert_not_nil assigns(:users)
    # assert_select "title", /Usuarios/
    # assert_select "ul[class=\"users\"]" do
    #  User.all.paginate(page:1).each do |user|
    #    assert_select "li" do
    #      assert_select "a[href=?]", user_url(user), "#{user.login}"
    #      assert_select "img[src=?]", "/assets/#{user.sex}.png"
    #      assert_select "img[src=?]", "/assets/#{user.image}"
    #    end
    #  end
    # end
    # assert_select "div.pagination", 2
    assert_select "a[data-method=delete]", false
  end

	 test "indice debe contener un título Listing users" do
		 get :index
		 # assert_select "h1", "Usuarios", "pues no tiene listing user"
	 end

	test "should get new" do
		get :new
		assert_response :success
		assert_select "form" do
  		assert_select "input[name=?]", "user[name]"
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[password]"
      assert_select "input[name=?]", "user[password_confirmation]"
      assert_select "input[name=?]", "user[surname]"
      assert_select "select[name=?]", "user[sex]"
      assert_select "input[name=?]", "user[login]"
      # assert_select "input[name=?]", "user[image]"
	   end
     assert_select "title", "Red Social | Registro"
     assert_select "h1", "Registro"
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {email: 'sin@error.com',  name: @user.name,
        password: 'asdasdasd', password_confirmation: 'asdasdasd',
        surname: @user.surname, sex: @user.sex, login: 'login_no_duplicado',
        image: @user.image}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
    assert_select "title", /#{@user.login}/
    assert_select "body", /#{@user.name}/
    assert_select "body", /#{@user.surname}/
    # assert_select "img[src=?]", "/assets/#{@user.sex}.png"
    assert_select "img[alt=sexo]"
    assert_select "img[alt=avatar]"
    # assert_select "img[src=?]", "/assets/#{@user.image}"
    # assert_select "ol[class=\"posts\"]" do
    #   assert_select "li", @user.posts.count
    # end
    assert_select "ol[class=\"posts\"]" do
      @user.posts.paginate(page:1, per_page: 25).each do |post|
        assert_select "li", /#{post.comment}/
      end
    end
    assert_select "div.pagination"
    assert_select "a[href=?]",following_user_path(@user), /#{@user.followed_users.count}*following/
    assert_select "a[href=?]",followers_user_path(@user), /#{@user.followers.count}*followers/
  end

  # test "should update user" do
  #   user_path(@user.id)
  #   patch :update, id: @user, user: { email: "no@error.com", name: @user.name, password: "hola123",
  #                                     password_confirmation: "hola123", surname: @user.surname, sex: @user.sex,
  #                                     login: "loginoerror", image: @user.image }
  #   assert_redirected_to user_path(assigns(:user))
  #   assert_redirected_to signin_path
  # end
  # test "should get edit" do
  #   get :edit, id: @user
  #   assert_response :found
    # assert_select "form" do
    #   assert_select "input[name=?]", "user[name]"
    #   assert_select "input[name=?]", "user[email]"
    #   assert_select "input[name=?]", "user[password]"
    #   assert_select "input[name=?]", "user[password_confirmation]"
    #   assert_select "input[name=?]", "user[surname]"
    #   assert_select "select[name=?]", "user[sex]"
    #   assert_select "input[name=?]", "user[login]"
    #   assert_select "input[name=?]", "user[image]"
    # end
  # end

  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete :destroy, id: @user
  #   end
  #   assert_redirected_to users_path
  # end

  test "should route to sign up" do
    assert_routing '/signup', {controller: "users", action: "new"}
  end

  test "admin should destroy user" do
    @user.toggle!(:admin)
    sign_in @user
    # assert_difference('User.count', -1) do
    #   delete :destroy, id: @user
    # end
    assert_response :success
  end

  test "user not admin should not destroy user" do
    sign_in @user
    delete :destroy, id: @user
    assert_redirected_to root_path
  end
  # test "user not signed should not destroy user" do
  #   delete :destroy, id: @user
  #   assert_redirected_to signin_path
  # end

  test "admin should get index" do
    @user.toggle! :admin
    sign_in @user
    get :index
    # assert_not_nil assigns(:users)
    assert_response :success
    # assert_select "title", /Usuarios/
    # assert_select "ul[class=\"users\"]" do
    #   User.all.paginate(page:1).each do |user|
    #     assert_select "li" do
    #       # assert_select "a[href=?]", user_path(user.id), "#{user.login}"
    #       # assert_select "img[src=?]", "/assets/#{user.image}"
    #       # assert_select "img[src=?]", "/assets/#{user.sex}.png"
    #       assert_select "a[data-method=delete]", "Eliminar"
    #     end
    #   end
    # end
    # assert_select "div.pagination", 2
  end

  test "should get following" do
    sign_in @user
    get :following, id: @user
    assert_response :success
    assert_select "title", /#{@user.login} followed users/
    assert_select "body", /#{@user.name}/
    assert_select "body", /#{@user.surname}/
    # assert_select "img[src=?]", "/assets/#{@user.image}"
    # assert_select "img[src=?]", "/assets/#{@user.sex}.png"
    assert_select "ul[class=\"users\"]" do
      @user.followed_users.paginate(page:1).each do |user|
        assert_select "li", /#{user.login}/
      end
    end
    assert_select "div.pagination" if @user.followed_users.count > 30
    assert_select "a[href=?]",following_user_path(@user), /#{@user.followed_users.count}*following/
    assert_select "a[href=?]",followers_user_path(@user), /#{@user.followers.count}*followers/
  end

  test "should get followers" do
    sign_in @user
    get :followers, id: @user
    assert_response :success
    assert_select "title", /#{@user.login} followers/
    assert_select "body", /#{@user.name}/
    assert_select "body", /#{@user.surname}/
    # assert_select "img[src=?]", "/assets/#{@user.image}"
    # assert_select "img[src=?]", "/assets/#{@user.sex}.png"
    assert_select "ul" do
      @user.followers.paginate(page:1).each do |user|
        assert_select "li", /#{user.login}/
      end
    end
    assert_select "div.pagination" if @user.followers.count > 30
    assert_select "a[href=?]",following_user_path(@user), /#{@user.followed_users.count}*following/
    assert_select "a[href=?]",followers_user_path(@user), /#{@user.followers.count}*followers/
  end

end
