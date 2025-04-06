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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ScreenTitle(
                    text: 'BEM-VINDO AO FUTSALLINK!',
                    bottomPadding: 8.0,
                  ),
                  
                  const SubtitleText(
                    text: 'Vamos criar seu perfil de jogador',
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Texto explicativo principal
                  Text(
                    'Nas próximas telas você irá preencher informações importantes que ajudarão clubes e olheiros a te encontrar.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nota de rodapé
                  Text(
                    'Não se preocupe, você poderá editar essas informações posteriormente.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  // Espaçamento extra no final (como nas outras telas)
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 