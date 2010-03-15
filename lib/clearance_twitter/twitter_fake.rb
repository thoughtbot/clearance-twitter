# See web_mock_twitter_fake.rb which supplies the following methods:
#
# stub_http_request_for_fake_twitter
#
module TwitterFake
  def stub_twitter_verify_credentials_for(options)
    twitter_username = options.delete(:twitter_username)
    twitter_id = options.delete(:twitter_id)
    response_json = <<-JSON
      {
        "screen_name":"#{twitter_username}",
        "id":"#{twitter_id}"
      }
    JSON

    verify_credentials_url = ClearanceTwitter.base_url + '/account/verify_credentials.json'
    stub_http_request_for_fake_twitter(:get, verify_credentials_url, {
      :status => 200,
      :body => response_json
    })
  end

  def stub_twitter_request_token
    stub_http_request_for_fake_twitter(:any, "#{ClearanceTwitter.base_url}/oauth/request_token", {
      :status => 200,
      :body => "oauth_token=this_need_not_be_real&oauth_token_secret=same_for_this"
    })
  end

  def stub_twitter_successful_access_token
    stub_http_request_for_fake_twitter(:any, "#{ClearanceTwitter.base_url}/oauth/access_token", {
      :status => 200,
      :body => "oauth_token=this_need_not_be_real&oauth_token_secret=same_for_this"
    })
  end

  def stub_twitter_denied_access_token
    stub_http_request_for_fake_twitter(:any, "#{ClearanceTwitter.base_url}/oauth/access_token", {
      :status => 401,
      :body => ''
    })
  end
end
