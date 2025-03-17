// Em apps/futsallink_player/lib/main_prod.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futsallink_club/app.dart';
import 'package:futsallink_club/core/config/firebase_options_prod.dart';
import 'package:futsallink_club/core/config/flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  FlavorConfig(flavor: Flavor.production);
  
  runApp(const FutsallinkClubApp(flavor: Flavor.production));
}