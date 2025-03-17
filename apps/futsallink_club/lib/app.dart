import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/config/app_config.dart';
import 'core/config/flavors.dart';

class FutsallinkClubApp extends StatelessWidget {
  final Flavor flavor;

  const FutsallinkClubApp({Key? key, required this.flavor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName, // ✅ Agora usa o nome correto
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF0E1A2A),
      ),
      initialRoute: AppRoutes.login, // ✅ Definindo login como a primeira tela
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
