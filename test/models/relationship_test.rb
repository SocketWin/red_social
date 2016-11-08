require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	# test "Comprobar atributos que deben estar inicializados" do
	# 	relation = Relationship.new
	# 	refute relation.valid?, "Debería ser invalido"
	# 	refute relation.errors[:follower_id].blank?, "debe tener un follower"
	# 	refute relation.errors[:followed_id].blank?, "debe tener un followed"
	# end

	# test "Comprobar existencia de los atributos" do
	# 	relation = Relationship.new
	# 	assert_respond_to relation, "follower_id"
	# 	assert_respond_to relation, "followed_id"
	# 	assert_respond_to relation, "follower"
	# 	# assert_respond_to relation, "followed"
	# 	assert_respond_to user, "followed_users"
	# end
	# test "Comprobar que Relationship solo acepta usuarios existentes" do
	# 	relation = Relationship.new
	# 	relation.follower_id = 1
	# 	relation.followed_id = 2
	# 	assert relation.invalid?, "El usuario follower no deberia existir"
	# 	relation.follower_id = 1
	# 	relation.followed_id = -1
	# 	assert relation.invalid?, "El usuario followed no debería existir"
	# end
	test "Comprobar que no se pueden introducir pares de usuario repetidos" do
		relation = Relationship.new
		relation.followed_id = 1
		relation.follower_id = 2
		assert_no_difference('User.count') do
			relation.save
		end
	end
	test "Comprobar que los usuarios son de la clase User" do
		relation = Relationship.first
		assert_operator relation.followed_users, "instance_of?", User
		assert_operator relation.follower, "instance_of?", User
	end
	test "Comprueba la existencia de métodos auxiliares" do
		user = User.new
		assert_respond_to user, "following?"
		assert_respond_to user, "follow!"
		assert_respond_to user, "unfollow!"
	end
	test "Comprueba si un usuario sigue a otro" do
		user = User.find_by(id:1)
		user_no_sigue = User.find_by_email("user5@gmail.com")
		user_si_sigue = User.find_by(id:2)
		refute user.following? user_no_sigue
		assert user.following? user_si_sigue
	end
	test "Comprueba el método follow!" do
		user = User.find_by(id:1)
		user_no_sigue = User.find_by_email("user4@gmail.com")
		assert_difference('Relationship.count') do
			user.follow!(user_no_sigue)
			assert_operator user.followed_users,"include?", user_no_sigue
		end
	end
	# test "Comprueba el método unfollow!" do
	# 	user = User.find_by(id:1)
	# 	p "Usuarios Seguidos >"
	# 	p user.followed_users.count
	# 	p "< fin"
	# 	user_sigue = user.followed_users.first
	# 	assert_difference('Relationship.count') do
	# 		user.unfollow!(user_sigue)
	# 		refute_operator user.followed_users,"include?", user_sigue
	# 	end
	# end
end
