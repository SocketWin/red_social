namespace :db do
  desc "Rellena datos para desarrollo"
  task populate: :environment do
    make_users
    make_posts
  end
  def make_users
    User.create!(name: "Usuario",
    surname: "Pruebas",
    sex: "Indefinido",
    login: "login",
    email: "user@gmail.com",
    password: "contraseña",
    password_confirmation: "contraseña")
    99.times do |n|
      name = Faker::Name.first_name
      surname = Faker::Name.last_name
      login = Faker::Internet.user_name
      login = "#{login}_#{n}"
      email = Faker::Internet.email
      email = "#{n}_#{email}"
      User.create!(name: name,
      surname: surname,
      sex: "Indefinido",
      login: login,
      email: email,
      password: "contraseña",
      password_confirmation: "contraseña")
    end
  end
  def make_posts
    users = User.limit(5)
    50.times do
      comment = Faker::Lorem.sentence(5)
      users.each { |user| user.posts.create!(comment: comment) }
    end
  end
end
