Feature: Sign in with Twitter OAuth
  In order to use their Twitter credentials for authentication.
  An existing user
  Should be able to sign in with Twitter OAuth

  Scenario: User has already signed up with Twitter OAuth
    Given there are no users
    And remote Twitter user exists with an username of "jerkcity"
    And a user exists that is connected to Twitter account "jerkcity"
    When I go to the sign in page
    And I click the Sign in with Twitter button
    And I grant access to the Twitter application for Twitter user "jerkcity"
    Then I should be signed in as Twitter user "jerkcity"
    And there should be 1 user in the system
