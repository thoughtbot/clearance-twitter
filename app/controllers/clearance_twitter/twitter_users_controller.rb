class ClearanceTwitter::TwitterUsersController < ApplicationController
  def new
    oauth_callback = request.protocol + request.host_with_port + '/oauth_callback'
    @request_token = ClearanceTwitter.consumer.get_request_token({:oauth_callback=>oauth_callback})
    session[:request_token] = @request_token.token
    session[:request_token_secret] = @request_token.secret
   
    url = @request_token.authorize_url
    # TODO: Test for this
    # url << "&oauth_callback=#{CGI.escape(ClearanceTwitter.oauth_callback)}" if ClearanceTwitter.oauth_callback?
    redirect_to url
  end
end
