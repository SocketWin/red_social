require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "h1","Bienvenido a Red Social"
    assert_select "title", "Red Social | Home"
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

end
