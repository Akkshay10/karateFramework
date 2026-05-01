Feature: Performance API Test
  Lightweight API feature file for Gatling performance testing.
  Uses baseUrl from karate-config.js for environment-agnostic execution.

  Background:
    * url baseUrl

  Scenario: GET request returns 200 status code
    Given path '/api/health'
    When method get
    Then status 200
