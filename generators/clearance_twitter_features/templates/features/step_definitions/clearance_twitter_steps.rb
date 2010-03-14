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

Then 'I should be directed to sign in with Twitter' do
  request_token = ClearanceTwitter.consumer.get_request_token
  assert_redirected_to request_token.authorize_url
end

Then /^there should be (\d+) users? in the system$/ do |count|
  assert_equal count.to_i, User.count, User.all.inspect
end

Then /^I should be signed in as Twitter user "(.*)" with ID (\d+)$/ do |twitter_username, twitter_id|
  assert user = User.find_by_twitter_username_and_twitter_id(twitter_username, twitter_id),
    "No user exists for Twitter username #{twitter_username.inspect} and Twitter ID #{twitter_id}.
     All users:\n#{User.all.inspect}"

  assert_equal user, @controller.current_user, "Not signed in as the correct Twitter user"
end

Then /^I should be signed in as Twitter user "(.*)" with ID (\d+) and email address "(.*)"$/ do |twitter_username, twitter_id, email|
  assert user = User.find_by_twitter_username_and_twitter_id(twitter_username, twitter_id),
    "No user exists for Twitter username #{twitter_username.inspect} and Twitter ID #{twitter_id} and email address #{email}.
     All users:\n#{User.all.inspect}"

  assert_equal user, @controller.current_user, "Not signed in as the correct Twitter user"
end

When 'I grant access to the Twitter application for Twitter user "$twitter_username" with ID $twitter_id' do |twitter_username, twitter_id|
  FakeTwitter.stub_twitter_successful_access_token
  FakeTwitter.stub_verify_credentials_for(:twitter_username => twitter_username, :twitter_id => twitter_id)

  visit oauth_callback_twitter_users_url(:oauth_token => 'this_need_not_be_real', :oauth_verifier => 'verifier')
end

When 'I deny access to the Twitter application' do
  FakeTwitter.stub_twitter_denied_access_token
  visit oauth_callback_twitter_users_url(:denied => 'denied_token')
end

Given /^the Twitter OAuth request is successful$/ do
  FakeTwitter.stub_twitter_request_token
end
