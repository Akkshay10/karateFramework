Feature: UI Sample Tests
  Demonstrates browser automation testing patterns using Karate's built-in driver.
  Uses uiBaseUrl from karate-config.js for environment-agnostic execution.

  Background:
    * configure driver = { type: 'chrome', headless: true }

  Scenario: Open a web page using configured UI base URL
    Given driver uiBaseUrl + '/login'
    Then waitFor('body')
    And match driver.url contains '/login'

  Scenario: Interact with page elements and validate resulting page state
    Given driver uiBaseUrl + '/login'
    And waitFor('#username')
    When input('#username', 'testuser')
    And input('#password', 'testpass')
    And click('#submit')
    Then waitFor('#dashboard')
    And match text('#welcome-message') contains 'testuser'

  Scenario: Handle timeout for element not found
    Given driver uiBaseUrl + '/login'
    And waitFor('#username')
    When input('#username', 'testuser')
    And input('#password', 'testpass')
    And click('#submit')
    Then retry(3, 1000).waitFor('#slow-loading-element')
