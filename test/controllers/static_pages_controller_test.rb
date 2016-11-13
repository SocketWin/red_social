require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    current_user = nil
    get :home
    assert_response :success
    assert_select "h1","Bienvenido a Red Social"
    assert_select "title", "Red Social | Home"
    assert_select "a", /Home/
    assert_select "a", /Help/
    assert_select "a", /Identificarse/
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "h1","Help"
    assert_select "title", "Red Social | Help"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "h1","Sobre Nosotros"
    assert_select "title", "Red Social | About"
  end

  test "should route to help" do
    assert_routing '/help', {controller: "static_pages", action: "help"}
  end

  test "should route to home" do
    assert_routing '/', {controller: "static_pages", action: "home"}
  end

  test "should route to about" do
    assert_routing '/about', {controller: "static_pages", action: "about"}
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "h1","Contacto"
    assert_select "title", "Red Social | Contacto"
  end

  test "should route to contact" do
    assert_routing '/contact', {controller: "static_pages", action: "contact"}
  end

  test "Comprobar cabeceras cuando estamos logueados" do
    sign_in User.first
    get :help
    assert_select "a", /Home/
    assert_select "a", /Help/
    # assert_select "a", /Usuarios/
    # assert_select "a", /Cuenta/
    # assert_select "a", /Perfil/
    # assert_select "a", /Configuración/
    # assert_select "a", /Cerrar sesión/
  end

  test "should get home signed" do
    sign_in User.first
    get :home
    assert_response :success
    assert_select "title", "Red Social | Home"
    assert_select "a[href=?]",following_user_path(current_user), /
    #{current_user.followed_users.count}*following/
    assert_select "a[href=?]",followers_user_path(current_user), /#{current_user.followers.count}*followers/
    # assert_select "body", /#{current_user.name}/
    # assert_select "body", /#{current_user.surname}/
    # assert_select "img[src=?]", "/assets/#{current_user.image}"
    # assert_select "img[src=?]", "/assets/#{current_user.sex}.png"
    # assert_select "ol[class=\"posts\"]" do
    #   current_user.feed.paginate(page:1, per_page: 25).each do |post|
    #     assert_select "li", /#{post.comment}/
    #   end
    # end
    # assert_select "div.pagination"
  end

end
