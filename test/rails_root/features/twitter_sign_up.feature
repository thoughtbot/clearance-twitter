Feature: Sign up with Twitter OAuth
  In order to use their Twitter credentials for authentication,
  A visitor to the site
  Should be able to sign up with Twitter OAuth

  @wip
  Scenario: User signs up with Twitter OAuth
    Given there are no users
    And remote Twitter user exists with an username of "jerkcity"
    When I am signed into Twitter account "jerkcity"
    And I go to the sign up page
    And I click the Twitter button
    Then I should be signed in as Twitter user "jerkcity"
    And there should be 1 user in the system

  @wip
  Scenario: User has already signed up with Twitter OAuth
    Given there are no users
    And remote Twitter user exists with an username of "jerkcity"
    And an user exists that is connected to Twitter account "jerkcity"
    When I go to the sign up page
    And I am signed into Twitter account "jerkcity"
    And I click the Twitter button
    Then I should be signed in as Twitter user "jerkcity"
    And there should be 1 user in the system
