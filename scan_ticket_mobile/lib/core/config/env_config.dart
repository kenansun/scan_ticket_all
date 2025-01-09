enum Environment {
  dev,    // 开发环境
  test,   // 测试环境
  prod    // 生产环境
}

class EnvConfig {
  static Environment currentEnv = Environment.dev;

  static final Map<Environment, String> _baseUrls = {
    Environment.dev: 'http://192.168.161.160:8080',  // 更新为正确的IP地址
    Environment.test: 'http://test-api.example.com', // 测试环境
    Environment.prod: 'https://api.example.com',     // 生产环境
  };

  static String getBaseUrl() {
    return _baseUrls[currentEnv] ?? _baseUrls[Environment.dev]!;
  }

  // 是否是开发环境
  static bool get isDev => currentEnv == Environment.dev;
  
  // 是否是测试环境
  static bool get isTest => currentEnv == Environment.test;
  
  // 是否是生产环境
  static bool get isProd => currentEnv == Environment.prod;

  // 获取当前环境名称
  static String get envName => currentEnv.toString().split('.').last.toUpperCase();
}
