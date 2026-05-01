Feature: API Sample Tests
  Demonstrates common API testing patterns using Karate.
  Uses baseUrl from karate-config.js for environment-agnostic execution.

  Background:
    * url baseUrl

  Scenario: GET request returns 200 status code
    Given path '/api/health'
    When method get
    Then status 200

  Scenario: Validate response body fields with match expressions
    Given path '/api/users'
    When method get
    Then status 200
    And match response.users == '#array'
    And match each response.users contains { id: '#number', name: '#string', email: '#string' }
    And match response.users[0].id == '#notnull'

  Scenario: Validate error response structure for 404 status
    Given path '/api/users/99999'
    When method get
    Then status 404
    And match response contains { error: '#string', status: 404 }
    And match response.error == '#notnull'
