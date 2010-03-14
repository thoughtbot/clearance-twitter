Feature: Sign in with Twitter OAuth
  In order to use their Twitter credentials for authentication.
  An existing user
  Should be able to sign in with Twitter OAuth

  Scenario: User signs in with Twitter
    Given there are no users
    And a user exists with a twitter username of "jerkcity"
    When I go to the sign in page
    And I click the Sign in with Twitter button
    And I grant access to the Twitter application for Twitter user "jerkcity"
    Then I should be signed in as Twitter user "jerkcity"
    And there should be 1 user in the system
