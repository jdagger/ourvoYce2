Feature: Visit Landing Page
  In order to make sure the the correct content is rendered when visiting the root url
  As a user visiting the page
  I want to see the correct landing page


  Scenario: Unauthenticated user
    Given I am logged out
    When I visit the landing page
    Then I should see "boo"



    #    Given a valid user
    #    And I am logged in
    #    When I visit the "Landing" page
    #    Then I should see "You are logged in as"
    #    And I should see "Viewing: Hot Topics"
    #    And I should see "Logout"
