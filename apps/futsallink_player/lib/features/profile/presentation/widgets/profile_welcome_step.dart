import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ProfileWelcomeStep extends StatelessWidget {
  const ProfileWelcomeStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Marca esta etapa como válida automaticamente
    Future.microtask(() {
      final cubit = context.read<ProfileCreationCubit>();
      final state = cubit.state;
      if (state is ProfileCreationActive && !state.isCurrentStepValid) {
        cubit.emit(state.copyWith(isCurrentStepValid: true));
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Bem-vindo ao Futsallink!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: FutsallinkColors.primary,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'Vamos criar seu perfil de jogador',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            const Text(
              'Nas próximas telas você irá preencher informações importantes que ajudarão clubes e olheiros a te encontrar.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Você precisará informar:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildListItem(context, 'Seus dados pessoais', Icons.person),
            _buildListItem(context, 'Data de nascimento', Icons.calendar_today),
            _buildListItem(context, 'Posição em que joga', Icons.sports_soccer),
            _buildListItem(context, 'Pé dominante', Icons.accessibility_new),
            _buildListItem(context, 'Altura e peso', Icons.height),
            _buildListItem(context, 'Uma foto para seu perfil', Icons.photo_camera),
            _buildListItem(context, 'Sua biografia e time atual', Icons.description),
            const SizedBox(height: 24),
            const Text(
              'Não se preocupe, você poderá editar essas informações posteriormente.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: FutsallinkColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
} 