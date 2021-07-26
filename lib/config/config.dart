import 'package:flutter_dotenv/flutter_dotenv.dart';

//Define abstract class to handle config related to environment
abstract class BaseConfig {
  String get apiHost;
  bool get useHttps;
}

// Dev configuration
class DevConfig implements BaseConfig {
  String get apiHost => dotenv.env["API_HOST"];
  bool get useHttps => false;
}

// Staging configuration
class StagingConfig implements BaseConfig {
  String get apiHost => dotenv.env["API_HOST"];
  bool get useHttps => true;
}

// Production configuration
class ProductionConfig implements BaseConfig {
  String get apiHost => dotenv.env["API_HOST"];
  bool get useHttps => true;
}

// Use singleton pattern to load correct environmnet configuration
class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PRODUCTION = 'PRODUCTION';

  BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environmnet) {
    switch (environmnet) {
      case Environment.PRODUCTION:
        return ProductionConfig();
      case Environment.STAGING:
        return StagingConfig();
      default:
        return DevConfig();
    }
  }
}
