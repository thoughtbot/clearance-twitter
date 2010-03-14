Feature: Sign up with Twitter OAuth
  In order to use their Twitter credentials for authentication,
  A visitor to the site
  Should be able to sign up with Twitter OAuth

  Scenario: User successfully signs up with Twitter OAuth
    Given there are no users
    And Twitter OAuth is faked
    And I go to the sign up page
    And I click the Sign in with Twitter button
    Then I should be directed to sign in with Twitter
    When I grant access to the Twitter application for Twitter user "jerkcity" with ID 999
    Then I should see "Successfully signed in with Twitter."
    And there should be 1 user in the system
    And I should be signed in as Twitter user "jerkcity" with ID 999

    # Deny access
    # http://beerfire.heroku.com/oauth_callback?denied=gDvIISsUyVIKEsMZSmMCWPUOy3VwMU5xcRfc52GzMqk

    # Allow access
    # http://beerfire.heroku.com/oauth_callback?oauth_token=HGvvHmjk94vmNM5sz8ny2wYIYQCpOewvxAmXaCs9Y8U&oauth_verifier=R8vGQeATOFW5BZXH65FCzMdj1uvpadFy4ENEuZvS1fs

# Given /^I am signed in as "@(.*)"$/ do |twitter_username|
#   @twitter_username = twitter_username
#   stub_post('https://twitter.com/oauth/request_token', 'access_token')  
#   stub_post('https://twitter.com/oauth/access_token', 'access_token')  
#   stub_get('https://twitter.com/account/verify_credentials.json', 'verify_credentials.json')  
#   visit path_to('the login page')  
#   visit path_to('the oauth callback page')  
# end 

  Scenario: User goes to sign up with Twitter but denies access
