require 'clearance_twitter/fake_twitter'

Before do
  FakeTwitterUser.clear_remote_profiles
  FakeTwitterSession.logout
end

Given /^there are no users$/ do
  User.delete_all
end

Given /^remote Twitter user exists with an username of "([^"]+)"$/ do |twitter_username|
  FakeTwitterUser.add_remote_profile({:username => twitter_username})
end

Given 'remote Twitter user exists with an username of "$username" and a name of "$name" and an email of "$email"' do |twitter_username, twitter_user_name, twitter_user_email|
  FakeTwitterUser.add_remote_profile({:id => twitter_username, :name => twitter_user_name, :email => twitter_user_email})
end

Given 'I am signed into Twitter account "$username"' do |twitter_username|
  twitter_user = FakeTwitterUser.get_remote_profile(twitter_username)
  FakeTwitterSession.login(twitter_user)
end

When 'I click the Twitter button' do
  click_link 'Sign in using Twitter'
end

Then /^there should be (\d+) users? in the system$/ do |count|
  assert_equal count.to_i, User.count, User.all.inspect
end

Given 'an user exists that is connected to Twitter account "$username"' do |twitter_username|
  Factory(:user, :twitter_username => twitter_username)
end

Then 'I should be signed in as Twitter user "$username"' do |twitter_username|
  assert user = User.find_by_twitter_username(twitter_username), "No user exists for Twitter username #{twitter_username.inspect}"
  assert_equal user, @controller.current_user, "Not signed in as the correct Twitter user"
end

And /^I sign out of Twitter$/ do
  FakeTwitterSession.logout
  visit url_for(
    :controller => 'clearance/sessions',
    :action     => 'destroy',
    :method     => :delete
  ), :delete
end

Then /^I should be signed out of Twitter$/ do
  assert !@controller.local_twitter_session?
end
