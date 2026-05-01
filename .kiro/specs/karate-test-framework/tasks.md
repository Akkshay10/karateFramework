# Implementation Plan: Karate Test Framework

## Overview

This plan builds a greenfield Gradle-based Karate test automation framework from scratch. Tasks are ordered so that foundational infrastructure (build script, project structure, configuration) is established first, followed by helper utilities, then test feature files for each test type, performance testing, reporting, and finally documentation. Each task builds incrementally on previous work, ensuring no orphaned code.

## Tasks

- [x] 1. Initialize Gradle project and build script
  - [x] 1.1 Create `settings.gradle` with project name `karate-test-framework`
    - Define the root project name
    - _Requirements: 1.1_
  - [x] 1.2 Create `build.gradle` with plugins, dependencies, and source sets
    - Apply `java`, `scala`, and `io.gatling.gradle` plugins
    - Declare dependencies: karate-core 1.4.1, karate-junit5 1.4.1, karate-gatling 1.4.1, kafka-clients 3.6.1, postgresql 42.7.1, cucumber-reporting 5.7.7 (all in `test` scope)
    - Configure source sets for `src/test/java`, `src/test/resources`, and `src/test/scala`
    - _Requirements: 1.1, 1.5_
  - [x] 1.3 Define Gradle test tasks for each test type
    - Create `apiTest`, `uiTest`, `kafkaTest`, `dbTest`, `mobileTest` tasks of type `Test`, each filtering by its corresponding Runner class
    - Create `perfTest` task for Gatling simulation execution
    - Each task passes `karate.env` system property with default `BLD`
    - _Requirements: 1.2, 1.3, 1.4_
  - [x] 1.4 Add Gradle wrapper files
    - Create `gradle/wrapper/gradle-wrapper.properties` with a compatible Gradle version
    - _Requirements: 1.1_

- [x] 2. Checkpoint
  - Verify the project compiles with `./gradlew build` (expect compilation success with no source files yet). Ensure all tasks are defined. Ask the user if questions arise.

- [x] 3. Create environment configuration
  - [x] 3.1 Create `src/test/resources/karate-config.js`
    - Implement the `fn()` function that reads `karate.env` (defaulting to `BLD`)
    - Define environment-specific config blocks for BLD, SIT, and PRE with `baseUrl`, `uiBaseUrl`, `dbUrl`, `dbUser`, `dbPassword`, `kafkaBrokers`, and `mobileAppId`
    - Throw an error with a descriptive message for unsupported environment values
    - Return the config object so all properties are accessible in feature files
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6_
  - [x] 3.2 Create `src/test/resources/logback-test.xml`
    - Configure logging for Karate test execution with reasonable defaults
    - _Requirements: 9.4_

- [x] 4. Create JUnit 5 runner classes
  - [x] 4.1 Create `src/test/java/runners/ApiRunner.java`
    - Implement `@Karate.Test` method targeting `classpath:api`
    - _Requirements: 9.2_
  - [x] 4.2 Create `src/test/java/runners/UiRunner.java`
    - Implement `@Karate.Test` method targeting `classpath:ui`
    - _Requirements: 9.2_
  - [x] 4.3 Create `src/test/java/runners/KafkaRunner.java`
    - Implement `@Karate.Test` method targeting `classpath:kafka`
    - _Requirements: 9.2_
  - [x] 4.4 Create `src/test/java/runners/DbRunner.java`
    - Implement `@Karate.Test` method targeting `classpath:db`
    - _Requirements: 9.2_
  - [x] 4.5 Create `src/test/java/runners/MobileRunner.java`
    - Implement `@Karate.Test` method targeting `classpath:mobile`
    - _Requirements: 9.2_

- [x] 5. Implement helper utility classes
  - [x] 5.1 Create `src/test/java/helpers/KafkaHelper.java`
    - Implement `produce(String brokers, String topic, String key, String value)` method using `KafkaProducer` with string serializers
    - Implement `consume(String brokers, String topic, String groupId, int timeoutMs)` method using `KafkaConsumer` that polls until timeout and returns `List<Map<String, Object>>`
    - Wrap connection failures in `RuntimeException` with descriptive messages including broker address
    - Close producer/consumer in `finally` blocks to prevent resource leaks
    - _Requirements: 5.1, 5.2, 5.5_
  - [x] 5.2 Create `src/test/java/helpers/PostgresHelper.java`
    - Implement `query(String dbUrl, String user, String password, String sql)` method that executes SELECT and returns `List<Map<String, Object>>` built from `ResultSet` column metadata
    - Implement `execute(String dbUrl, String user, String password, String sql)` method that executes INSERT/UPDATE/DELETE and returns affected row count
    - Wrap connection failures in `RuntimeException` with descriptive messages including DB URL
    - Close connection, statement, and result set in `finally` blocks to prevent resource leaks
    - _Requirements: 6.1, 6.2, 6.5, 6.6_

- [x] 6. Checkpoint
  - Ensure the project compiles successfully with `./gradlew build`. Verify all runner classes and helper classes compile. Ask the user if questions arise.

- [x] 7. Create API test feature files
  - [x] 7.1 Create `src/test/resources/api/api-sample.feature`
    - Write a scenario that sends an HTTP GET request to `baseUrl` from config and validates the response status code is 200
    - Write a scenario that validates response body fields using Karate match expressions
    - Write a scenario that validates error response structure for an error status code
    - Use `baseUrl` from `karate-config.js` so the test is environment-agnostic
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

- [x] 8. Create UI test feature files
  - [x] 8.1 Create `src/test/resources/ui/ui-sample.feature`
    - Write a scenario that configures the Chrome browser driver
    - Write a scenario that opens a web page using `uiBaseUrl` from config
    - Write a scenario that interacts with page elements (input fields, buttons) and validates resulting page state
    - Include timeout handling for element-not-found scenarios
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [x] 9. Create Kafka test feature files
  - [x] 9.1 Create `src/test/resources/kafka/kafka-sample.feature`
    - Write a scenario that uses `KafkaHelper` via `Java.type('helpers.KafkaHelper')` to produce a message to a topic
    - Write a scenario that consumes the produced message and verifies its content
    - Use `kafkaBrokers` from `karate-config.js` for environment-agnostic execution
    - _Requirements: 5.3, 5.4_

- [x] 10. Create database test feature files
  - [x] 10.1 Create `src/test/resources/db/db-sample.feature`
    - Write a scenario that uses `PostgresHelper` via `Java.type('helpers.PostgresHelper')` to execute a SELECT query and validate returned data
    - Use `dbUrl`, `dbUser`, `dbPassword` from `karate-config.js` for environment-agnostic execution
    - _Requirements: 6.3, 6.4_

- [x] 11. Create mobile test feature files
  - [x] 11.1 Create `src/test/resources/mobile/mobile-sample.feature`
    - Write a scenario that configures the mobile driver with desired capabilities (e.g., Android)
    - Write a scenario that interacts with mobile elements (tap, input text) and validates screen state
    - Use `mobileAppId` from `karate-config.js` for environment-agnostic execution
    - Include timeout handling for element-not-found scenarios
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

- [x] 12. Checkpoint
  - Ensure the project compiles successfully with `./gradlew build`. Verify all feature files are syntactically valid. Ask the user if questions arise.

- [x] 13. Implement Gatling performance simulation
  - [x] 13.1 Create `src/test/resources/performance/perf-api.feature`
    - Write a lightweight API feature file suitable for performance testing (simple GET request with status validation)
    - Use `baseUrl` from config for environment-agnostic execution
    - _Requirements: 8.4_
  - [x] 13.2 Create `src/test/scala/performance/ApiPerformanceSimulation.scala`
    - Extend Gatling `Simulation` class
    - Use `karateProtocol()` and `karateFeature()` to wrap the `perf-api.feature` file
    - Configure user injection with `rampUsers` and `during` for concurrent users and ramp-up duration
    - _Requirements: 8.1, 8.2, 8.3_

- [x] 14. Implement Cucumber reporting
  - [x] 14.1 Add `generateCucumberReport` Gradle task to `build.gradle`
    - Create a task that invokes `net.masterthought.cucumber.ReportBuilder` programmatically
    - Configure it to read Karate JSON output from `build/karate-reports/`
    - Output HTML reports to `target/cucumber-html-reports/`
    - Output JSON report to `target/cucumber-reports/cucumber.json`
    - Ensure the JSON output follows standard Cucumber JSON format with feature objects, scenario objects, step results (name, keyword, status, duration, error_message)
    - Handle missing input gracefully: log a warning and skip if no JSON files exist
    - Wire the report task to run after test tasks via `finalizedBy`
    - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5, 12.1, 12.2, 12.3, 12.4, 12.5, 12.6_

- [x] 15. Checkpoint
  - Ensure the project compiles successfully with `./gradlew build`. Verify the Gatling simulation compiles and the report task is defined. Ask the user if questions arise.

- [x] 16. Create README documentation
  - [x] 16.1 Create `README.md` at the project root
    - Describe the overall project structure and the purpose of each directory (`api/`, `ui/`, `kafka/`, `db/`, `mobile/`, `performance/`, `runners/`, `helpers/`)
    - List the Gradle command to run each test type: `apiTest`, `uiTest`, `kafkaTest`, `dbTest`, `mobileTest`, `perfTest`
    - Document environment selection via `-Dkarate.env=<ENV>` with valid values BLD, SIT, PRE
    - Document the `generateCucumberReport` task and report output locations
    - Include prerequisites: Java 11+, Gradle version, and external service dependencies (Kafka broker, Postgres, mobile device/emulator, web application)
    - _Requirements: 10.1, 10.2, 10.3, 10.4_

- [x] 17. Final checkpoint
  - Ensure the full project compiles with `./gradlew build`. Verify all files are in the correct directory structure per the design. Ensure all tests pass, ask the user if questions arise.

## Notes

- No property-based tests are included because the framework consists of declarative configuration, I/O wrappers, and example test files — there are no pure functions with universal properties suitable for PBT.
- Each task references specific requirements for traceability.
- Checkpoints are placed after foundational setup, after helpers, after feature files, and at the end for incremental validation.
- Feature files use placeholder URLs and credentials from `karate-config.js`; actual values should be updated per environment.
- Running individual test types (e.g., `kafkaTest`, `dbTest`) requires the corresponding external services to be available.
