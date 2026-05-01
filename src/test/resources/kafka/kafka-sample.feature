Feature: Kafka Sample Tests
  Demonstrates Kafka message production and consumption using KafkaHelper.
  Uses kafkaBrokers from karate-config.js for environment-agnostic execution.

  Background:
    * def KafkaHelper = Java.type('helpers.KafkaHelper')

  Scenario: Produce a message to a Kafka topic and consume it to verify content
    # Produce a JSON message to the test topic
    * def topic = 'test-topic'
    * def messageKey = 'key1'
    * def messageValue = '{"msg":"hello","source":"karate-test"}'
    * KafkaHelper.produce(kafkaBrokers, topic, messageKey, messageValue)

    # Consume messages from the same topic and verify the produced message
    * def messages = KafkaHelper.consume(kafkaBrokers, topic, 'karate-test-group', 5000)
    * match messages == '#array'
    * match messages.length != 0
    * def lastMessage = messages[messages.length - 1]
    * match lastMessage.key == messageKey
    * match lastMessage.value == messageValue
    * match lastMessage.topic == topic

  Scenario: Produce and consume a message with structured JSON payload
    * def topic = 'test-topic-json'
    * def messageKey = 'order-001'
    * def payload = { orderId: 'ORD-123', amount: 49.99, status: 'CREATED' }
    * def messageValue = karate.toString(payload)
    * KafkaHelper.produce(kafkaBrokers, topic, messageKey, messageValue)

    # Consume and parse the JSON payload for field-level validation
    * def messages = KafkaHelper.consume(kafkaBrokers, topic, 'karate-json-group', 5000)
    * match messages == '#array'
    * match messages.length != 0
    * def lastMessage = messages[messages.length - 1]
    * def parsed = karate.fromString(lastMessage.value)
    * match parsed.orderId == 'ORD-123'
    * match parsed.amount == 49.99
    * match parsed.status == 'CREATED'
