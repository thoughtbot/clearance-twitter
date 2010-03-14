Feature: Sign in with Twitter OAuth
  In order to use their Twitter credentials for authentication.
  An existing user
  Should be able to sign in with Twitter OAuth

  Scenario: User signs in with Twitter
    Given there are no users
    And the Twitter OAuth request is successful
    And the following user exists:
      | twitter_username | twitter_id |
      | jerkcity         | 999        |
    When I go to the sign in page
    And I click the Sign in with Twitter button
    Then I should be directed to sign in with Twitter
    When I grant access to the Twitter application for Twitter user "jerkcity" with ID 999
    Then I should see "Successfully signed in with Twitter."
    And there should be 1 user in the system
    And I should be signed in as Twitter user "jerkcity" with ID 999

  Scenario: Signed in user connects their Twitter account
    Given the Twitter OAuth request is successful
    And I am signed up and confirmed as "email@example.com/password"
    When I sign in as "email@example.com/password"
    And I am on the sign in page
    And I click the Sign in with Twitter button
    Then I should be directed to sign in with Twitter
    When I grant access to the Twitter application for Twitter user "jerkcity" with ID 999
    Then I should see "Successfully signed in with Twitter."
    And there should be 1 user in the system
    And I should be signed in as Twitter user "jerkcity" with ID 999 and email address "email@example.com"
