Feature: Sign up with Twitter OAuth
  In order to use their Twitter credentials for authentication,
  A visitor to the site
  Should be able to sign up with Twitter OAuth

  Scenario: User successfully signs up with Twitter OAuth
    Given there are no users
    And the Twitter OAuth request is successful
    And I go to the sign up page
    And I click the Sign in with Twitter button
    Then I should be directed to sign in with Twitter
    When I grant access to the Twitter application for Twitter user "jerkcity" with ID 999
    Then I should see "Successfully signed in with Twitter."
    And there should be 1 user in the system
    And I should be signed in as Twitter user "jerkcity" with ID 999

  Scenario: User goes to sign up with Twitter but denies access
    Given there are no users
    And the Twitter OAuth request is successful
    And I go to the sign up page
    And I click the Sign in with Twitter button
    Then I should be directed to sign in with Twitter
    When I deny access to the Twitter application
    Then I should see "There was a problem trying to authenticate you. Please try again."
    And there should be 0 users in the system
    And I should be signed out
