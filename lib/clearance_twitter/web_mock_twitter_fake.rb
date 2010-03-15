require 'webmock'

module WebMockTwitterFake
  def disable_remote_http
    WebMock.disable_net_connect!
  end

  def stub_http_request_for_fake_twitter(method, url, response_options)
    WebMock.stub_request(method, url).to_return(response_options)
  end
end
