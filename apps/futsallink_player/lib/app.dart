import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'core/di/injection_container.dart';
import 'core/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/config/app_config.dart';
import 'core/config/flavors.dart';

class FutsallinkPlayerApp extends StatelessWidget {
  final Flavor flavor;

  const FutsallinkPlayerApp({Key? key, required this.flavor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        // Adicione outros BlocProviders aqui
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xFF0E1A2A),
        ),
        initialRoute: '/login', // Usando string direta ao invés de AppRoutes
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
