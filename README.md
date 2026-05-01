# Karate Test Framework

A comprehensive Gradle-based test automation framework built on [Karate 1.4.1](https://github.com/karatelabs/karate). It provides a unified solution for API, UI (browser), Kafka messaging, database (Postgres), mobile, and performance testing — all driven by Gherkin-style `.feature` files and executable with simple Gradle commands.

## Prerequisites

| Prerequisite | Version / Details |
|---|---|
| **Java** | 11 or later (JDK required) |
| **Gradle** | 8.5 (included via the Gradle Wrapper — no separate install needed) |
| **Kafka broker** | Required for `kafkaTest`. A running Apache Kafka instance reachable at the address configured in `karate-config.js` |
| **PostgreSQL** | Required for `dbTest`. A running Postgres instance with the database, user, and password configured in `karate-config.js` |
| **Web application** | Required for `uiTest`. The target web app must be accessible at the `uiBaseUrl` configured in `karate-config.js`. Chrome browser must be installed on the test machine |
| **Mobile device / emulator** | Required for `mobileTest`. An Android emulator or physical device with the app under test installed, plus Appium server running |

> **Note:** The Gradle Wrapper (`gradlew` / `gradlew.bat`) is checked in, so you do not need to install Gradle separately. All commands below use `./gradlew`.

## Project Structure

```
karate-test-framework/
├── build.gradle                          # Build script: plugins, dependencies, tasks
├── settings.gradle                       # Gradle project name
├── gradlew / gradlew.bat                 # Gradle Wrapper scripts
├── gradle/wrapper/                       # Gradle Wrapper JAR and properties
├── README.md                             # This file
└── src/test/
    ├── java/
    │   ├── runners/                      # JUnit 5 runner classes (one per test type)
    │   │   ├── ApiRunner.java
    │   │   ├── UiRunner.java
    │   │   ├── KafkaRunner.java
    │   │   ├── DbRunner.java
    │   │   └── MobileRunner.java
    │   └── helpers/                      # Reusable Java helper utilities
    │       ├── KafkaHelper.java
    │       └── PostgresHelper.java
    ├── scala/
    │   └── performance/                  # Gatling simulation classes (Scala)
    │       └── ApiPerformanceSimulation.scala
    └── resources/
        ├── karate-config.js              # Environment-aware Karate configuration
        ├── logback-test.xml              # Logging configuration
        ├── api/                          # API test feature files
        │   └── api-sample.feature
        ├── ui/                           # UI / browser test feature files
        │   └── ui-sample.feature
        ├── kafka/                        # Kafka messaging test feature files
        │   └── kafka-sample.feature
        ├── db/                           # Database (Postgres) test feature files
        │   └── db-sample.feature
        ├── mobile/                       # Mobile test feature files
        │   └── mobile-sample.feature
        └── performance/                  # Performance test feature files (used by Gatling)
            └── perf-api.feature
```

### Directory Descriptions

| Directory | Purpose |
|---|---|
| `api/` | Feature files for REST API testing — HTTP requests, response validation, error handling |
| `ui/` | Feature files for browser-based UI testing using Karate's built-in driver |
| `kafka/` | Feature files for Kafka message production and consumption tests |
| `db/` | Feature files for PostgreSQL database query and data validation tests |
| `mobile/` | Feature files for mobile application testing via Karate's mobile driver |
| `performance/` | Lightweight feature files executed under load by Gatling simulations |
| `runners/` | JUnit 5 runner classes — each runner targets a single feature directory so Gradle tasks can execute test types independently |
| `helpers/` | Reusable Java utilities (`KafkaHelper`, `PostgresHelper`) callable from feature files via `Java.type()` |

## Running Tests

Each test type has a dedicated Gradle task. Use the Gradle Wrapper to run them:

```bash
# API tests
./gradlew apiTest

# UI / browser tests
./gradlew uiTest

# Kafka messaging tests
./gradlew kafkaTest

# Database (Postgres) tests
./gradlew dbTest

# Mobile tests
./gradlew mobileTest

# Performance tests (Gatling)
./gradlew perfTest
```

All test tasks (except `perfTest`) automatically trigger Cucumber report generation when they finish.

## Environment Configuration

The framework supports three environments, controlled by the `karate.env` system property:

| Environment | Description |
|---|---|
| `BLD` | Build / development environment (default) |
| `SIT` | System integration testing environment |
| `PRE` | Pre-production environment |

Pass the environment on the command line with `-Dkarate.env=<ENV>`:

```bash
# Run API tests against the SIT environment
./gradlew apiTest -Dkarate.env=SIT

# Run Kafka tests against PRE
./gradlew kafkaTest -Dkarate.env=PRE

# Default (BLD) — no flag needed
./gradlew dbTest
```

If an unsupported value is provided, `karate-config.js` throws an error listing the valid options.

Environment-specific settings (base URLs, database connection strings, Kafka broker addresses, mobile app IDs) are defined in `src/test/resources/karate-config.js`. Update the placeholder values in that file to match your actual environment endpoints before running tests.

## Reporting

### Cucumber HTML Reports

After any test task completes, the `generateCucumberReport` task runs automatically and produces a human-readable HTML report.

**Output location:** `target/cucumber-html-reports/`

The report includes:
- Each executed scenario with its name, steps, and pass/fail status
- A summary showing total scenarios, passed count, and failed count

### Cucumber JSON Reports

A Cucumber-compatible JSON report is generated alongside the HTML report.

**Output location:** `target/cucumber-reports/cucumber.json`

The JSON follows the standard Cucumber format (feature objects → scenario objects → step results with name, keyword, status, duration, and error messages). This file is compatible with the **Xray** Cucumber JSON import endpoint for uploading test execution results to Jira.

### Generating Reports Manually

If you want to regenerate reports without re-running tests:

```bash
./gradlew generateCucumberReport
```

This reads Karate's JSON output from `build/karate-reports/` and produces both HTML and JSON reports. If no JSON files are found, the task logs a warning and skips gracefully.

### Gatling Reports

Performance test runs (`perfTest`) produce Gatling's own HTML report in `build/reports/gatling/`. This report includes request timing distributions, throughput graphs, and pass/fail breakdowns.

## External Service Dependencies

Some test types require external services to be running and reachable:

| Test Type | Required Service | Configuration Property |
|---|---|---|
| `kafkaTest` | Apache Kafka broker | `kafkaBrokers` in `karate-config.js` |
| `dbTest` | PostgreSQL database | `dbUrl`, `dbUser`, `dbPassword` in `karate-config.js` |
| `uiTest` | Target web application + Chrome browser | `uiBaseUrl` in `karate-config.js` |
| `mobileTest` | Mobile device/emulator + Appium server | `mobileAppId` in `karate-config.js` |
| `apiTest` | Target REST API | `baseUrl` in `karate-config.js` |
| `perfTest` | Target REST API | `baseUrl` in `karate-config.js` |

Tests will fail with descriptive error messages if the required service is unavailable.
