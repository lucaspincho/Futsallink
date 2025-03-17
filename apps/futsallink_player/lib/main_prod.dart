// Em apps/futsallink_player/lib/main_prod.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futsallink_player/app.dart';
import 'package:futsallink_player/core/config/firebase_options_prod.dart';
import 'package:futsallink_player/core/di/injection_container.dart';
import 'package:futsallink_player/core/config/flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initDependencies();
  
  FlavorConfig(flavor: Flavor.production);
  
  runApp(const FutsallinkPlayerApp(flavor: Flavor.production,));
}