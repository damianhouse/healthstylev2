# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.create!(first_name: "Damian", last_name: "House", email: "damianhouse@gmail.com", password: "password", is_admin: true, phone_number: "2342342342").save

# coaches
5.times do
  User.create!(first_name: Faker::Space.planet, last_name: Faker::Space.planet, email: Faker::Internet.email, password: 'password', is_coach: true, phone_number: Faker::PhoneNumber.cell_phone, greeting: Faker::ChuckNorris.fact, philosophy: Faker::ChuckNorris.fact, avatar: Faker::Avatar.image("my-own-slug", "50x50", "jpg"), approved: true).save
end
# users
5.times do
  User.create!(first_name: Faker::Space.planet, last_name: Faker::Space.planet, email: Faker::Internet.email, password: 'password', phone_number: Faker::PhoneNumber.cell_phone, avatar: Faker::Avatar.image("my-own-slug", "50x50", "jpg")).save
end
