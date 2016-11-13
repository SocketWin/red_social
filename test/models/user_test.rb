require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	test "password debe tener como mínimo 6 char" do
		 user = User.new(email: "User1@gmail.com", name: "User1", surname: "Surname1", password: "asd")
		 assert user.invalid?
	 end

	test "Email debe ser uniq" do
		user1 = User.new(email: "EsteMailNoSeHaUtilizadoAntes@gmail.com", name: "User360", surname: "Surname360",
										 password: "asd123", password_confirmation: "asd123", sex: "Hombre", login: "log360")
		 assert user1.save
		 user2 = User.new(email: "EsteMailNoSeHaUtilizadoAntes@gmail.com", name: "User2", surname: "Surname2", password: "asdasd")
		refute user2.save, "No se pueden guardar dos usuarios con el mismo email"
	end

	test "Comprobar existencia de los atributos" do
		user = User.new
		assert_respond_to user, "name"
		assert_respond_to user, "surname"
		assert_respond_to user, "password"
		assert_respond_to user, "password_confirmation"
		assert_respond_to user, "login"
		assert_respond_to user, "email"
		assert_respond_to user, "sex"
		assert_respond_to user, "image"
		assert_respond_to user, "posts"
		assert_respond_to user, "remember_token"
		assert_respond_to user, "authenticate"
	end
	test "Comprobar atributos que deben estar inicializados" do
		user = User.new
		refute user.valid?, "Debería ser invalido"
		refute user.errors[:name].blank?, "debe tener name"
		refute user.errors[:surname].blank?, "debe tener surname"
		refute user.errors[:password].blank?, "debe tener password"
		refute user.errors[:login].blank?, "debe tener login"
		refute user.errors[:email].blank?, "debe tener email"
	end
	test "Comprobar valores por defecto" do
		user = User.new
		assert_equal user.sex, "Indefinido"
		assert_equal user.image, "imagen_defecto.png"
	 end
	test "password debe tener como mínimo 6 char y estar confirmada" do
		user = User.first
		user.password = "asd"
		user.password_confirmation = "asd"
		# refute user.valid?, "No debería ser válido por el tamaño de la contraseña"
		user.password = "asdasd"
		user.password_confirmation = "asdasd"
		assert user.valid? , " Debería ser válido"
		user.password = "asdasd123"
		user.password_confirmation = "asdasd123"
		assert user.valid? , "También debería ser válido"
		user.password = "asdasdasd"
		user.password_confirmation = "asdasdqwe"
		refute user.valid?, "password y password_confirmation deben ser iguales"
	end
	test "Comprobar valores permitidos para sex" do
		user = User.new
		user.sex = "Si por favor"
		assert user.invalid?, "No debe aceptar valores distintos de Hombre, Mujer o No definido"
	end
	test "Comprobar email es uniq" do
		user = User.first.dup
		user.password = "password"
		user.password_confirmation = "password"
		user.login = "Login_No_Registrado"
		refute user.save, "No se pueden guardar dos usuarios con el mismo email"
	end
	test "Comprobar login es uniq" do
		user = User.first.dup
		user.password = "password"
		user.password_confirmation = "password"
		user.email = "Email_No_Registrado"
		refute user.save, "No se pueden guardar dos usuarios con el mismo login"
	end

	test "Comprobar que cuando guardamos un usuario se crea un remember_token" do
		user = User.last.dup
		user.remember_token = nil
		user.password = "password"
		user.password_confirmation = "password"
		user.email = "Email_No_Registrado"
		user.login = "Login_No_Registrado"
		user.save
		refute_nil user.remember_token
	end

end
