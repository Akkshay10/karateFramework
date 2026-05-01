function fn() {
    var env = karate.env || 'BLD';
    var config = { env: env };

    if (env === 'BLD') {
        config.baseUrl = 'https://api.bld.example.com';
        config.uiBaseUrl = 'https://app.bld.example.com';
        config.dbUrl = 'jdbc:postgresql://db.bld.example.com:5432/testdb';
        config.dbUser = 'test_user';
        config.dbPassword = 'test_pass';
        config.kafkaBrokers = 'kafka.bld.example.com:9092';
        config.mobileAppId = 'com.example.app.bld';
    } else if (env === 'SIT') {
        config.baseUrl = 'https://api.sit.example.com';
        config.uiBaseUrl = 'https://app.sit.example.com';
        config.dbUrl = 'jdbc:postgresql://db.sit.example.com:5432/testdb';
        config.dbUser = 'test_user';
        config.dbPassword = 'test_pass';
        config.kafkaBrokers = 'kafka.sit.example.com:9092';
        config.mobileAppId = 'com.example.app.sit';
    } else if (env === 'PRE') {
        config.baseUrl = 'https://api.pre.example.com';
        config.uiBaseUrl = 'https://app.pre.example.com';
        config.dbUrl = 'jdbc:postgresql://db.pre.example.com:5432/testdb';
        config.dbUser = 'test_user';
        config.dbPassword = 'test_pass';
        config.kafkaBrokers = 'kafka.pre.example.com:9092';
        config.mobileAppId = 'com.example.app.pre';
    } else {
        throw new Error('Unsupported environment: ' + env + '. Valid: BLD, SIT, PRE');
    }

    return config;
}
