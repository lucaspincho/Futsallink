import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      appBar: AppBar(
        title: const Text('FutsalLink'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FutsallinkSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo ao FutsalLink!',
                style: FutsallinkTypography.headline1.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: FutsallinkSpacing.md),
              Text(
                'Encontre e participe de partidas de futsal próximas a você.',
                style: FutsallinkTypography.headline2.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: FutsallinkSpacing.xl),
              // Aqui você pode adicionar mais widgets para a tela inicial
              // Por exemplo: lista de partidas, botões de ação, etc.
            ],
          ),
        ),
      ),
    );
  }
} 