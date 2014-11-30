ENV['RAILS_ENV'] ||= 'test'

# all users are already activated
# first user is an administrator
  name = Faker::Name.name.split
  first_name = name[0]
  last_name = name[1]
  nickname = first_name[0,3] + last_name[0,3]
  nickname.downcase!
  admin = true
  email = "example@railstutorial.org"
  password = "password"
  activated_at = Time.zone.now
  u = User.create(admin: admin, activated: true, activated_at: activated_at, nickname:  nickname, first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password)
  u.save

99.times do |n|
  name = Faker::Name.name.split
  first_name = name[0]
  last_name = name[1]
  nickname = first_name[0,3] + last_name[0,3]
  nickname.downcase!
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  activated_at = Time.zone.now
  u = User.create(activated: true, activated_at: activated_at, nickname:  nickname, first_name: first_name, last_name: last_name, email: email, password: password, password_confirmation: password)
  u.save
end

users = User.order(:created_at).take(6)
5.times do
  content = Faker::Lorem.sentence(5)
  title = Faker::Lorem.words(4).join(" ")
  users.each  do |user| 
     p = Post.create!( 
        title: Faker::Lorem.words(4).join(" "), 
        content: Faker::Lorem.sentence(5), 
        is_owned_by: user
     ) 
     puts "User: #{user}"
     puts "Post: #{p}"
  end
end