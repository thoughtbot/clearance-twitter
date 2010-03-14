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

    # From: http://bkocik.net/2009/05/07/testing-twitter-oauth-with-cucumber-webrat-and-fakeweb/
    # module FakewebHelpers  
    #   # Make sure nothing gets out (IMPORTANT)  
    #   FakeWeb.allow_net_connect = false  
    #   
    #   # Turns a fixture file name into a full path  
    #   def fixture_file(filename)  
    #     return '' if filename == ''  
    #     File.expand_path(RAILS_ROOT + '/test/fixtures/' + filename)  
    #   end  
    #   
    #   # Convenience methods for stubbing URLs to fixtures  
    #   def stub_get(url, filename)  
    #     FakeWeb.register_uri(:get, url, :response => fixture_file(filename))  
    #   end  
    #   
    #   def stub_post(url, filename)  
    #     FakeWeb.register_uri(:post, url, :response => fixture_file(filename))  
    #   end  
    #   
    #   def stub_any(url, filename)  
    #     FakeWeb.register_uri(:any, url, :response => fixture_file(filename))  
    #   end  
    # end  

    def stub_oauth
      # From: http://bkocik.net/2009/05/07/testing-twitter-oauth-with-cucumber-webrat-and-fakeweb/
      stub_request(:any, "#{ClearanceTwitter.base_url}/oauth/access_token", {
        :status => 200,
        :body => "oauth_token=this_need_not_be_real&oauth_token_secret=same_for_this"
      })
      stub_request(:any, "#{ClearanceTwitter.base_url}/oauth/request_token", {
        :status => 200,
        :body => "oauth_token=this_need_not_be_real&oauth_token_secret=same_for_this"
      })

      # stub_get('http://twitter.com/account/verify_credentials.json', 'verify_credentials.json')  
    end


    # def oauth_paths_to_stub
    #   [ClearanceTwitter.config['authorize_path'],
    #     '/oauth/request_token',
    #     '/oauth/authorize',
    #     '/oauth/access_token']
    # end
  end
end

