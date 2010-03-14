class FakeTwitter

  class << self
    attr_accessor :backend
  end

  # Delegate class methods to an instance of the backend of choice
  def self.method_missing(args)
    self.backend ||= FakeTwitter::WebMockBackend.new
    self.backend.send(*args)
  end

  class FakeOAuthRequestToken
    attr_accessor :authorize_url, :token, :secret
    def initialize(attributes)
      attributes.each { |key, value| send(:"#{key}=", value) }
    end
  end

  class FakeOAuthConsumer
    attr_accessor :get_request_token
    def initialize(attributes)
      attributes.each { |key, value| send(:"#{key}=", value) }
    end
  end

  require 'webmock'

  class WebMockBackend
    def disable_remote_http
      WebMock.disable_net_connect!
    end

    def stub_request(method, url, response_options)
      # method :get, :post, :any
      # response_options = { :status => '...', :body => '...' }
      WebMock.stub_request(method, url).to_return(response_options)
    end

    def stub_oauth
      FakeTwitter.oauth_paths_to_stub.each do |path|
        stub_request(:any, ClearanceFacebook.configuration['base_url'] + path, :body => '')
      end

      ClearanceFacebook.oauth_consumer = fake_oauth_consumer
    end

    def add_user(twitter_username)
    end

    private

    def fake_oauth_consumer
      FakeOAuthConsumer.new({
        :get_request_token => fake_request_token
      })
    end

    def fake_request_token
      authorize_url = ClearanceFacebook.config['base_url'] +
                      ClearanceFacebook.config['authorize_path']

      FakeOAuthRequestToken.new({
        :authorize_url => authorize_url,
        :token => 'token',
        :secret => 'secret'
      })
    end

    def oauth_paths_to_stub
      [ClearanceFacebook.configuration['authorize_path'],
        '/oauth/request_token',
        '/oauth/authorize',
        '/oauth/access_token']
    end


  end
end

Given /^Twitter OAuth is faked$/ do
  [TwitterAuth.config['authorize_path'], '/oauth/request_token', '/oauth/authorize', '/oauth/access_token'].each do |path|
    FakeWeb.register_uri(:any, TwitterAuth.config['base_url'] + path, :body => '')
  end

  request_token = stub('request_token',
                       :authorize_url => TwitterAuth.config['base_url'] + TwitterAuth.config['authorize_path'],
                       :token => 'token',
                       :secret => 'secret')
  consumer = stub('consumer', :get_request_token => request_token)
  TwitterAuth.stubs(:consumer).returns(consumer)
end

Then /^I should be directed to Twitter OAuth$/ do
  assert_redirected_to(TwitterAuth.config['base_url'] + TwitterAuth.config['authorize_path'] + '&oauth_callback=' + CGI.escape(TwitterAuth.config['oauth_callback']))
end

When /^I return from Twitter OAuth with a valid OAuth verifier for "@([^\"]*)"$/ do |username|
  user = stub('user', :id => '1', :remember_me => '2', :login => 'boys', :geocoded_location => FakeGeocoder.geocode() )
  request_token = stub('request_token', :get_access_token => 'access_token')
  User.stubs(:identify_or_create_from_access_token).returns(user)
  CrushesController.any_instance.stubs(:current_user).returns(user)
  OAuth::RequestToken.stubs(:new).returns(request_token)
  visit oauth_callback_url(:oauth_token => 'token', :oauth_verifier => 'verifier')
end

