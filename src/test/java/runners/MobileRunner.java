package runners;

import com.intuit.karate.junit5.Karate;

class MobileRunner {
    @Karate.Test
    Karate testMobile() {
        return Karate.run("classpath:mobile").relativeTo(getClass());
    }
}
