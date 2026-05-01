package helpers;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class KafkaHelper {

    public static void produce(String brokers, String topic, String key, String value) {
        KafkaProducer<String, String> producer = null;
        try {
            Properties props = new Properties();
            props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, brokers);
            props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
            props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
            producer = new KafkaProducer<>(props);
            producer.send(new ProducerRecord<>(topic, key, value)).get();
        } catch (Exception e) {
            throw new RuntimeException("Failed to connect to Kafka broker at " + brokers + ": " + e.getMessage(), e);
        } finally {
            if (producer != null) {
                producer.close();
            }
        }
    }

    public static List<Map<String, Object>> consume(String brokers, String topic, String groupId, int timeoutMs) {
        KafkaConsumer<String, String> consumer = null;
        try {
            Properties props = new Properties();
            props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, brokers);
            props.put(ConsumerConfig.GROUP_ID_CONFIG, groupId);
            props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
            props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
            props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
            consumer = new KafkaConsumer<>(props);
            consumer.subscribe(Collections.singletonList(topic));

            List<Map<String, Object>> messages = new ArrayList<>();
            long endTime = System.currentTimeMillis() + timeoutMs;

            while (System.currentTimeMillis() < endTime) {
                ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(Math.max(1, endTime - System.currentTimeMillis())));
                for (ConsumerRecord<String, String> record : records) {
                    Map<String, Object> message = new HashMap<>();
                    message.put("topic", record.topic());
                    message.put("key", record.key());
                    message.put("value", record.value());
                    message.put("partition", record.partition());
                    message.put("offset", record.offset());
                    message.put("timestamp", record.timestamp());
                    messages.add(message);
                }
            }

            return messages;
        } catch (Exception e) {
            throw new RuntimeException("Failed to connect to Kafka broker at " + brokers + ": " + e.getMessage(), e);
        } finally {
            if (consumer != null) {
                consumer.close();
            }
        }
    }
}
