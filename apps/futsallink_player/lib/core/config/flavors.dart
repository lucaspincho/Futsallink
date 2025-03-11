// Em apps/futsallink_player/lib/core/config/flavors.dart

enum Flavor {
  development,
  production,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  
  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      flavor.toString().split('.').last,
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name);
  
  static FlavorConfig get instance => _instance!;
  
  static bool isDevelopment() => _instance!.flavor == Flavor.development;
  static bool isProduction() => _instance!.flavor == Flavor.production;
}