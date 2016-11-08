require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	test "El comentario debe tener de 3 a 140 caracteres" do
    post = Post.new
		post.comment = "as"
    refute post.save, "Fallamos 1"
		post.comment = ("hola "*200)
    refute post.save, "Fallamos 2"
  end
  test "Comprobar existencia de los atributos" do
    post = Post.new
    assert_respond_to post, "comment"
    assert_respond_to post, "user_id"
    assert_respond_to post, "user"
  end
  test "Comprobar que user es de la clase User" do
    post = Post.first
    assert_operator post.user, "kind_of?", User
  end
  # test "Comprobar que post solo acepta usuarios existentes" do
  #   post = Post.first
  #   post.user_id = -1
  #   assert post.invalid?
  # end
  test "Comprobar atributos que deben estar inicializados" do
    post = Post.new
    refute post.valid?, "Debería ser invalido"
    refute post.errors[:comment].blank?, "debe tener un comment"
    refute post.errors[:user_id].blank?, "debe tener user_id"
  end
  test "Comments deben estar entre 3 y 140" do
    post = Post.first
    post.comment = "a"
    assert post.invalid?
    post.comment = "abeed"
    assert post.valid?
    post.comment = ("a" * 140)
    assert post.valid?
    post.comment = ("a" * 141)
    assert post.invalid?
  end
  test "Comprobar que los posts aparecen en orden de creación, primero los nuevos" do
    user = User.first
    post_antiguo = user.posts.create(comment: "Comentario escrito hace 1 dia",
      created_at: 1.day.ago)
    post_nuevo = user.posts.create(comment: "Comentario escrito hace 1 hora",
      created_at: 1.hour.ago)
    assert_operator user.posts.first.created_at, ">=", user.posts.second.created_at
  end
  test "Comprobar que si matamos al usuario los posts asociados desaparecen" do
    user = User.first
    user.posts.create(comment: "comentario")
    user.posts.create(comment: "comentario")
    posts_ids = user.post_ids.to_a
    user.destroy
    posts_ids.each do |id|
    refute Post.exists?(id)
    end
  end
end
