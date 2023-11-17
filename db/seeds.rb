# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

['a','b','c','d','e','f'].each do |l|
  User.create(email: "#{l}@#{l}.com",
              password: 'password',
              password_confirmation: 'password',
              name: "#{l}#{l}#{l}".capitalize,
              last_name: "#{l}#{l}#{l}#{l}".capitalize)
end

User.all.each do |user|
  uri = 'https://a.espncdn.com/combiner/i?img=/i/teamlogos/soccer/500/2026.png'
  user.photo.attach(io: URI.parse(uri).open, filename: "profile.#{uri.split('.').last}")
end

50.times do
  Post.create(user_id: rand(1..6), content: Array('a'..'z').sample(14).join)
end