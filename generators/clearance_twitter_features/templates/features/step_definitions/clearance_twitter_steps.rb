require 'clearance_twitter/fake_twitter'

Before do
  # You can override the HTTP faking implementation like this, if you prefer:
  # FakeTwitter.implemenation = FakeTwitter::SomeOtherBackend.new
  #
  # The default uses WebMock via FakeTwitter::WebMockBackend
  FakeTwitter.disable_remote_http
end

Given 'there are no users' do
  User.delete_all
end

When 'I click the Sign in with Twitter button' do
  click_link 'Sign in using Twitter'
end

Then /^there should be (\d+) users? in the system$/ do |count|
  assert_equal count.to_i, User.count, User.all.inspect
end

Then 'I should be signed in as Twitter user "$username"' do |twitter_username|
  assert user = User.find_by_twitter_username(twitter_username), "No user exists for Twitter username #{twitter_username.inspect}"
  assert_equal user, @controller.current_user, "Not signed in as the correct Twitter user"
end

When 'I grant access to the Twitter application for Twitter user "$twitter_username"' do |twitter_username|
  pending # express the regexp above with the code you wish you had
end

When 'I deny access to the Twitter application' do
end

# Given /^remote Twitter user exists with an username of "([^\"]*)"$/ do |arg1|
#   pending # express the regexp above with the code you wish you had
# end
# 
# Given /^a user exists that is connected to Twitter account "([^\"]*)"$/ do |arg1|
#   pending # express the regexp above with the code you wish you had
# end
# 
# When /^I am signed into Twitter account "([^\"]*)"$/ do |arg1|
#   pending # express the regexp above with the code you wish you had
# end
