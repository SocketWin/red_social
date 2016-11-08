require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", /Iniciar sesión/
    assert_select "h1", "Iniciar sesión"
    assert_select "form" do
      assert_select "input[name=?]", "session[login]"
      assert_select "input[name=?]", "session[password]"
    end
  end

  test "should create session" do
    post :create, session: { login: 'user1surname0', password: "contraseña"}
    # assert_redirected_to user_path(User.find_by_login('user1surname0').id)
    assert_response :success
  end
  test "should fail create session" do
    post :create, session: { login: 'user1surname0', password: "Fallo"}
    assert_equal flash[:error], "Fallo de autenticación: Los datos son incorrectos"
  end
end
