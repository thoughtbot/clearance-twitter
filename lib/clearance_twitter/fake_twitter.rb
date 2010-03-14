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

    def get_request_token(*args)
      @get_request_token
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
        stub_request(:any, ClearanceTwitter.base_url + path, :body => '')
      end

      ClearanceTwitter.consumer = fake_oauth_consumer
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
      authorize_url = ClearanceTwitter.base_url +
                      ClearanceTwitter.config['authorize_path']

      FakeOAuthRequestToken.new({
        :authorize_url => authorize_url,
        :token => 'token',
        :secret => 'secret'
      })
    end

    def oauth_paths_to_stub
      [ClearanceTwitter.config['authorize_path'],
        '/oauth/request_token',
        '/oauth/authorize',
        '/oauth/access_token']
    end
  end
end

