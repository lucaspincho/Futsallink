import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ProfilePositionStep extends StatefulWidget {
  const ProfilePositionStep({Key? key}) : super(key: key);

  @override
  State<ProfilePositionStep> createState() => _ProfilePositionStepState();
}

class _ProfilePositionStepState extends State<ProfilePositionStep> {
  final List<String> positions = [
    'Goleiro',
    'Fixo',
    'Ala Esquerda',
    'Ala Direita',
    'Pivô',
  ];

  String? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _initSelectedPosition();
  }

  void _initSelectedPosition() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      if (state.player.position.isNotEmpty) {
        if (state.player.position == "Universal") {
          context.read<ProfileCreationCubit>().updatePosition("");
        } else {
          setState(() {
            _selectedPosition = state.player.position;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    text: 'QUAL SUA POSIÇÃO?',
                    bottomPadding: 8.0,
                  ),
                  
                  const SubtitleText(
                    text: 'Selecione a sua posição preferida dentro de quadra.',
                  ),
                  
                  const SizedBox(height: 40),
                  
                  ...positions.map((position) => _buildPositionTile(position)),                  
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPositionTile(String position) {
    final bool isSelected = position == _selectedPosition;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPosition = position;
          });
          context.read<ProfileCreationCubit>().updatePosition(position);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSelected 
              ? Colors.white.withOpacity(0.15) 
              : FutsallinkColors.darkBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? FutsallinkColors.primary : Colors.white.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              _getPositionIcon(position),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPositionDescription(position),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: FutsallinkColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getPositionIcon(String position) {
    switch (position) {
      case 'Goleiro':
        return const Icon(Icons.sports_handball, color: FutsallinkColors.primary);
      case 'Fixo':
        return const Icon(Icons.shield, color: FutsallinkColors.primary);
      case 'Ala Esquerda':
        return const Icon(Icons.arrow_back, color: FutsallinkColors.primary);
      case 'Ala Direita':
        return const Icon(Icons.arrow_forward, color: FutsallinkColors.primary);
      case 'Pivô':
        return const Icon(Icons.sports_soccer, color: FutsallinkColors.primary);
      default:
        return const Icon(Icons.sports_soccer, color: FutsallinkColors.primary);
    }
  }

  String _getPositionDescription(String position) {
    switch (position) {
      case 'Goleiro':
        return 'Protege o gol e inicia as jogadas';
      case 'Fixo':
        return 'Responsável pela defesa e organização de jogo';
      case 'Ala Esquerda':
        return 'Atua pelo lado esquerdo da quadra';
      case 'Ala Direita':
        return 'Atua pelo lado direito da quadra';
      case 'Pivô':
        return 'Joga mais avançado, próximo ao gol adversário';
      default:
        return '';
    }
  }
} 