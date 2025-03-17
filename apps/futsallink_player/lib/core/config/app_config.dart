import 'flavors.dart';

class AppConfig {
  
  static Flavor get appFlavor => FlavorConfig.instance.flavor;

  static bool get isDevelopment => appFlavor == Flavor.development;
  static bool get isProduction => appFlavor == Flavor.production;

  static String get appName {
    switch (appFlavor) {
      case Flavor.development:
        return "Futsallink Player (DEV)";
      case Flavor.production:
        return "Futsallink Player";
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
    // Corrigir para usar o ID real do projeto
    return "futsallink-project";
  }
}