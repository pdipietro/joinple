ENV['RAILS_ENV'] ||= 'test'

99.times do |n|
  name = Faker::Name.name.split
  first_name = name[0]
  last_name = name[1]
  nickname = first_name[0,3] + last_name[0,3]
  nickname.downcase!
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  u = User.create(nickname:  nickname, first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password)
  u.save
end