package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class ApiPerformanceSimulation extends Simulation {

  val protocol = karateProtocol()

  val apiTest = scenario("API Performance")
    .exec(karateFeature("classpath:performance/perf-api.feature"))

  setUp(
    apiTest.inject(rampUsers(10).during(30.seconds))
  ).protocols(protocol)
}
