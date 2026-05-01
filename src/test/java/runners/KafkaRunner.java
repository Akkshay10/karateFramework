package runners;

import com.intuit.karate.junit5.Karate;

class KafkaRunner {
    @Karate.Test
    Karate testKafka() {
        return Karate.run("classpath:kafka").relativeTo(getClass());
    }
}
