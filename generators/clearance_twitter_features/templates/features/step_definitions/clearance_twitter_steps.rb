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

# Then 'I should be directed to sign in with Twitter' do
#   assert_redirected_to 'foo.com'
# end

Then /^there should be (\d+) users? in the system$/ do |count|
  assert_equal count.to_i, User.count, User.all.inspect
end

Then 'I should be signed in as Twitter user "$username" with ID $twitter_id' do |twitter_username, twitter_id|
  assert user = User.find_by_twitter_username_and_twitter_id(twitter_username, twitter_id),
    "No user exists for Twitter username #{twitter_username.inspect} and Twitter ID #{twitter_id}.
     All users:\n#{User.all.inspect}"

  assert_equal user, @controller.current_user, "Not signed in as the correct Twitter user"
end

When 'I grant access to the Twitter application for Twitter user "$twitter_username" with ID $twitter_id' do |twitter_username, twitter_id|
  FakeTwitter.stub_verify_credentials_for(:twitter_username => twitter_username, :twitter_id => twitter_id)
  visit oauth_callback_twitter_users_url(:oauth_token => 'this_need_not_be_real', :oauth_verifier => 'verifier')
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

Given /^Twitter OAuth is faked$/ do
  FakeTwitter.stub_oauth
  # [TwitterAuth.config['authorize_path'], '/oauth/request_token', '/oauth/authorize', '/oauth/access_token'].each do |path|
  #   FakeWeb.register_uri(:any, TwitterAuth.config['base_url'] + path, :body => '')
  # end

  # request_token = stub('request_token',
  #                      :authorize_url => TwitterAuth.config['base_url'] + TwitterAuth.config['authorize_path'],
  #                      :token => 'token',
  #                      :secret => 'secret')
  # consumer = stub('consumer', :get_request_token => request_token)
  # TwitterAuth.stubs(:consumer).returns(consumer)
end

# Then /^I should be directed to Twitter OAuth$/ do
#   assert_redirected_to(TwitterAuth.config['base_url'] + TwitterAuth.config['authorize_path'] + '&oauth_callback=' + CGI.escape(TwitterAuth.config['oauth_callback']))
# end

