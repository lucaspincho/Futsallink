import 'flavors.dart';

class AppConfig {
  static late Flavor appFlavor;

  static void initialize(Flavor flavor) {
    appFlavor = flavor;
  }

  static bool get isDevelopment => appFlavor == Flavor.development;
  static bool get isProduction => appFlavor == Flavor.production;

  static String get appName {
    switch (appFlavor) {
      case Flavor.development:
        return "Futsallink Club (DEV)";
      case Flavor.production:
        return "Futsallink Club";
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.development:
        return "https://api-dev.futsallink.com";
      case Flavor.production:
        return "https://api.futsallink.com";
    }
  }

  static String get firebaseProjectId {
    switch (appFlavor) {
      case Flavor.development:
        return "futsallink-dev";
      case Flavor.production:
        return "futsallink-prod";
    }
  }
}
