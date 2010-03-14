# TODO: Add World(FakeTwitter::WebMockHelpers) to features/support/env.rb in generator
#       thereby allowing user to change this easily without the method_missing crap.

class FakeTwitter

  class << self
    attr_accessor :backend
  end

  # Delegate class methods to an instance of the backend of choice
  def self.method_missing(*args)
    self.backend ||= FakeTwitter::WebMockBackend.new
    self.backend.send(*args)
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

    def stub_verify_credentials_for(options)
      twitter_username = options.delete(:twitter_username)
      twitter_id = options.delete(:twitter_id)
      response_json = <<-JSON
        {
          "screen_name":"#{twitter_username}",
          "id":"#{twitter_id}"
        }
      JSON

      verify_credentials_url = ClearanceTwitter.base_url + '/account/verify_credentials.json'
      stub_request(:get, verify_credentials_url, {
        :status => 200,
        :body => response_json
      })
    end

    def stub_twitter_request_token
      stub_request(:any, "#{ClearanceTwitter.base_url}/oauth/request_token", {
        :status => 200,
        :body => "oauth_token=this_need_not_be_real&oauth_token_secret=same_for_this"
      })
    end

    def stub_twitter_successful_access_token
      stub_request(:any, "#{ClearanceTwitter.base_url}/oauth/access_token", {
        :status => 200,
        :body => "oauth_token=this_need_not_be_real&oauth_token_secret=same_for_this"
      })
    end

    def stub_twitter_denied_access_token
      stub_request(:any, "#{ClearanceTwitter.base_url}/oauth/access_token", {
        :status => 401,
        :body => ''
      })
    end
  end
end

