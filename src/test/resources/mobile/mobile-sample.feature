Feature: Mobile Sample Tests
  Demonstrates mobile automation testing patterns using Karate's built-in mobile driver.
  Uses mobileAppId from karate-config.js for environment-agnostic execution.

  Background:
    * configure driver = { type: 'android', webDriverUrl: 'http://localhost:4723/wd/hub', start: false, httpConfig: { readTimeout: 120000 } }
    * configure driver.desiredCapabilities = { app: mobileAppId, platformName: 'Android', automationName: 'UiAutomator2', deviceName: 'emulator-5554', newCommandTimeout: 300 }

  Scenario: Configure mobile driver and launch app
    Given driver { type: 'android', webDriverUrl: 'http://localhost:4723/wd/hub', start: false, httpConfig: { readTimeout: 120000 }, desiredCapabilities: { app: '#(mobileAppId)', platformName: 'Android', automationName: 'UiAutomator2', deviceName: 'emulator-5554' } }
    Then waitFor('#splash-screen')
    And retry(5, 2000).waitFor('#home-screen')
    And match exists('#home-screen') == true

  Scenario: Interact with mobile elements and validate screen state
    Given driver { type: 'android', webDriverUrl: 'http://localhost:4723/wd/hub', start: false, httpConfig: { readTimeout: 120000 }, desiredCapabilities: { app: '#(mobileAppId)', platformName: 'Android', automationName: 'UiAutomator2', deviceName: 'emulator-5554' } }
    And waitFor('#home-screen')
    When click('#login-button')
    And waitFor('#login-screen')
    And input('#username-field', 'testuser')
    And input('#password-field', 'testpass')
    And click('#submit-button')
    Then waitFor('#dashboard-screen')
    And match text('#welcome-label') contains 'testuser'

  Scenario: Handle timeout for element not found on mobile
    Given driver { type: 'android', webDriverUrl: 'http://localhost:4723/wd/hub', start: false, httpConfig: { readTimeout: 120000 }, desiredCapabilities: { app: '#(mobileAppId)', platformName: 'Android', automationName: 'UiAutomator2', deviceName: 'emulator-5554' } }
    And waitFor('#home-screen')
    When click('#navigate-button')
    Then retry(3, 1000).waitFor('#slow-loading-screen')
