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
    'Universal',
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
        setState(() {
          _selectedPosition = state.player.position;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qual a sua posição?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecione a posição em que você joga',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ...positions.map((position) => _buildPositionTile(position)),
            const SizedBox(height: 24),
            const Text(
              'Escolha a posição principal em que você atua. Você poderá adicionar outras posições posteriormente.',
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
            color: isSelected ? FutsallinkColors.primary.withOpacity(0.1) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? FutsallinkColors.primary : Colors.transparent,
              width: 2,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPositionDescription(position),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
      case 'Universal':
        return const Icon(Icons.all_inclusive, color: FutsallinkColors.primary);
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
      case 'Universal':
        return 'Adaptável a diferentes posições da quadra';
      default:
        return '';
    }
  }
} 