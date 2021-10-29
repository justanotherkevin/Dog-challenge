# no bundle in 2.5.7
# rbenv: bundle: command not found
# The `bundle' command exists in these Ruby versions:
#   2.3.7
#   2.4.4
#   2.5.1
#   2.6.5
#   2.6.6
#   2.6.7
# solve with gem install bundler

# add owner to dog
rails g migration add_user_to_dogs user:references
rails db:migrate

rails g migration add_likes_to_dogs likes:integer
rails db:migrate

u = FactoryBot.create(:user)
User.new(email: 'test+123@test.test')
Dog.where(user_id: nil).count
Dog.where(user_id: nil).each do |d|
  d.owner = u
  d.save
  p d.id
end