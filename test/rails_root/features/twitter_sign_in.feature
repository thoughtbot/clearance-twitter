Feature: Sign in with Twitter OAuth
  In order to use their Twitter credentials for authentication.
  An existing user
  Should be able to sign in with Twitter OAuth

  @wip
  Scenario: User has already signed up with Twitter OAuth
    Given remote Twitter user exists with an username of "jerkcity"
    And an user exists that is connected to Twitter account "jerkcity"
    When I go to the sign in page
    And I am signed into Twitter account "jerkcity"
    And I click the Twitter button
    Then I should be signed in as Twitter user "jerkcity"
    And there should be 1 user in the system

  @wip
  Scenario: User has already signed up, but their account is not linked to Twitter
    Given remote Twitter user exists with an username of "jerkcity" and a name of "Alice Appleton" and an email of "user@example.com"
    And an email confirmed user exists with an email of "user@example.com"
    When I go to the sign in page
    And I am signed into Twitter account "jerkcity"
    And I click the Twitter button
    Then I should be signed in as Twitter user "jerkcity"
    And there should be 1 user in the system

  Scenario: A user with a Twitter account signs out
    Given remote Twitter user exists with an username of "jerkcity"
    And an user exists that is connected to Twitter account "jerkcity"
    When I go to the sign in page
    And I am signed into Twitter account "jerkcity"
    And I click the Twitter button
    Then I should be signed in as Twitter user "jerkcity"
    When I go to the homepage
    And I sign out of Twitter
    Then I should be signed out
    And I should be signed out of Twitter
