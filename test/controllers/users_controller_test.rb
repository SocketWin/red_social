require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_select "title", /Usuarios/
    # assert_select "ul[class=\"users\"]" do
    #  User.all.paginate(page:1).each do |user|
    #    assert_select "li" do
    #      assert_select "a[href=?]", user_url(user), "#{user.login}"
    #      assert_select "img[src=?]", "/assets/#{user.sex}.png"
    #      assert_select "img[src=?]", "/assets/#{user.image}"
    #    end
    #  end
    # end
    assert_select "div.pagination", 2
  end

	 test "indice debe contener un título Listing users" do
		 get :index
		 assert_select "h1", "Usuarios", "pues no tiene listing user"
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
      assert_select "input[name=?]", "user[image]"
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
  end

  test "should update user" do
    #user_path(assigns(:user))
    patch :update, id: @user, user: { email: "no@error.com", name: @user.name, password:
    "hola123", password_confirmation: "hola123", surname:
    @user.surname, sex: @user.sex, login: "loginoerror", image: @user.image }
    assert_redirected_to user_path(assigns(:user))
  end
  test "should get edit" do
    get :edit, id: @user
    assert_response :success
    assert_select "form" do
      assert_select "input[name=?]", "user[name]"
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[password]"
      assert_select "input[name=?]", "user[password_confirmation]"
      assert_select "input[name=?]", "user[surname]"
      assert_select "select[name=?]", "user[sex]"
      assert_select "input[name=?]", "user[login]"
      assert_select "input[name=?]", "user[image]"
    end
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end

  test "should route to sign up" do
    assert_routing '/signup', {controller: "users", action: "new"}
  end

end
