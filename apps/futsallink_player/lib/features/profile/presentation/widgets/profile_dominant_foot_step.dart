import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ProfileDominantFootStep extends StatefulWidget {
  const ProfileDominantFootStep({Key? key}) : super(key: key);

  @override
  State<ProfileDominantFootStep> createState() => _ProfileDominantFootStepState();
}

class _ProfileDominantFootStepState extends State<ProfileDominantFootStep> {
  final List<Map<String, dynamic>> dominantFootOptions = [
    {
      'value': 'Direito',
      'icon': Icons.arrow_forward,
      'description': 'Preferência pelo pé direito para chutes e passes'
    },
    {
      'value': 'Esquerdo',
      'icon': Icons.arrow_back,
      'description': 'Preferência pelo pé esquerdo para chutes e passes'
    },
  ];

  String? _selectedFoot;

  @override
  void initState() {
    super.initState();
    _initSelectedFoot();
  }

  void _initSelectedFoot() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      if (state.player.dominantFoot.isNotEmpty) {
        // Se o jogador tinha "Ambos" selecionado anteriormente, resetamos para null
        if (state.player.dominantFoot == "Ambos") {
          context.read<ProfileCreationCubit>().updateDominantFoot("");
        } else {
          setState(() {
            _selectedFoot = state.player.dominantFoot;
          });
        }
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
            const ScreenTitle(
              text: 'QUAL SEU PÉ DOMINANTE?',
              bottomPadding: 8.0,
            ),
            const SubtitleText(
              text: 'Selecione o pé com o qual você tem mais habilidade',
            ),
            const SizedBox(height: 32),
            ...dominantFootOptions.map((option) => _buildFootTile(option)),
          ],
        ),
      ),
    );
  }

  Widget _buildFootTile(Map<String, dynamic> option) {
    final bool isSelected = option['value'] == _selectedFoot;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFoot = option['value'];
          });
          context.read<ProfileCreationCubit>().updateDominantFoot(option['value']);
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
              Icon(
                option['icon'] as IconData,
                color: FutsallinkColors.primary,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['value'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option['description'] as String,
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
} 