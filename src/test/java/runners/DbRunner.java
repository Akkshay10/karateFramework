package runners;

import com.intuit.karate.junit5.Karate;

class DbRunner {
    @Karate.Test
    Karate testDb() {
        return Karate.run("classpath:db").relativeTo(getClass());
    }
}
