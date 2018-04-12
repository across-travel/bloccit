require 'random_data'
require 'faker'

# Create Users
10.times do
  User.create!(
    name:     Faker::Name.name,
    username: "@" + Faker::Name.first_name,
    email:    Faker::Internet.email,
    password: 'password',
    confirmed_at: Time.now
  )
end

# Create an admin user
admin = User.create!(
  name:     'Admin User',
  username: '@admin',
  email:    'admin@example.com',
  password: 'password',
  role:     'admin',
  confirmed_at: Time.now
)

# Create a member
member = User.create!(
  name:     'Member User',
  username: '@member',
  email:    'member@example.com',
  password: 'password',
  confirmed_at: Time.now
)

users = User.all

# Create Topics
15.times do
  Topic.create!(
    name:         Faker::Name.title,
    description:  Faker::Lorem.sentence(3),
    user: admin
  )
end
topics = Topic.all

# Create Posts
50.times do
post = Post.create!(
  user:   users.sample,
  topic: topics.sample,
  title:  Faker::Name.title,
  body:   Faker::Lorem.paragraph
)

post.update_attribute(:created_at, rand(10.minutes .. 1.year).ago)
rand(1..5).times { post.votes.create!(value: [-1, 1].sample, user: users.sample) }

end
posts = Post.all

# Create Comments
100.times do
post = posts.sample
Comment.create!(
  user: users.sample,
  post: post,
  commentable: post,
  body: RandomData.random_paragraph
)
end

# Following relationships
user  = users.last
following = users[4..6]
followers = users[1..3]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Subscriptions
subscribe_topics = topics[10..12]
subscribe_topics.each { |topic| user.subscribe(topic) }


puts "Seed finished"
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{User.count} users created"
puts "#{Vote.count} votes created"
