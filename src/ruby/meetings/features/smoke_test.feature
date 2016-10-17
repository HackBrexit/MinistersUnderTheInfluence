@smoketest
Feature: The basic functions of the website should be working
  As a developer
  I want to make sure the basic functions of the website are working
  So that I can continue with devlopment
  

  @javascript 
  Scenario: There is a navabar
    When I go to the home page
    Then I should see a navbar
    And it should have a home button on the left
    And it should have flags on the right

