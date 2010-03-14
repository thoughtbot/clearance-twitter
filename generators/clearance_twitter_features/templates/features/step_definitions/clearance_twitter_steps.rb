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
  assert user = User.find_by_twitter_username(twitter_username), "No user exists for Twitter username #{twitter_username.inspect}.  Users:\n#{User.all.inspect}"
  assert_equal user, @controller.current_user, "Not signed in as the correct Twitter user"
end

When 'I grant access to the Twitter application for Twitter user "$twitter_username"' do |twitter_username|
  # user = stub('user', :id => '1', :remember_me => '2', :login => 'boys', :geocoded_location => FakeGeocoder.geocode() )
  # request_token = stub('request_token', :get_access_token => 'access_token')
  # User.stubs(:identify_or_create_from_access_token).returns(user)
  # CrushesController.any_instance.stubs(:current_user).returns(user)
  # OAuth::RequestToken.stubs(:new).returns(request_token)
  #
# {:session_id=>"4f7fe62bf1ed8509899b954469b12e16", :request_token_secret=>"same_for_this", :request_token=>"this_need_not_be_real"}
# ---Params---
# {"action"=>"oauth_callback", "oauth_verifier"=>"verifier", "oauth_token"=>"token", "controller"=>"clearance_twitter/twitter_users"}
#     And I grant access to the Twitter application for Twitter user "jerk
  
  FakeTwitter.stub_verify_credentials_for(twitter_username)
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

