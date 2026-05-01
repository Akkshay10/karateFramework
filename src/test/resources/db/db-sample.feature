Feature: Database Sample Tests
  Demonstrates database testing patterns using PostgresHelper.
  Uses dbUrl, dbUser, dbPassword from karate-config.js for environment-agnostic execution.

  Background:
    * def DbHelper = Java.type('helpers.PostgresHelper')

  Scenario: Execute a SELECT query and validate returned data
    # Query the users table for a specific user by ID
    * def result = DbHelper.query(dbUrl, dbUser, dbPassword, "SELECT id, name, email FROM users WHERE id = 1")
    * match result == '#array'
    * match result.length == 1
    * def user = result[0]
    * match user.id == 1
    * match user.name == '#string'
    * match user.email == '#string'

  Scenario: Execute a SELECT query and validate multiple rows
    # Query all active users and verify the result structure
    * def result = DbHelper.query(dbUrl, dbUser, dbPassword, "SELECT id, name, email, status FROM users WHERE status = 'ACTIVE'")
    * match result == '#array'
    * match each result contains { id: '#number', name: '#string', email: '#string', status: 'ACTIVE' }

  Scenario: Execute a count query and validate the result
    # Verify the total count of records in the users table
    * def result = DbHelper.query(dbUrl, dbUser, dbPassword, "SELECT count(*) AS total FROM users")
    * match result == '#array'
    * match result.length == 1
    * match result[0].total == '#number'
