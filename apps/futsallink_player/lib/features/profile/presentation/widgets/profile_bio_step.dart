import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ProfileBioStep extends StatefulWidget {
  const ProfileBioStep({Key? key}) : super(key: key);

  @override
  State<ProfileBioStep> createState() => _ProfileBioStepState();
}

class _ProfileBioStepState extends State<ProfileBioStep> {
  final _bioController = TextEditingController();
  final int _maxBioLength = 300;
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _bioController.addListener(_updateCharacterCount);
    _updateCurrentStep();
  }

  void _initializeFields() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      if (state.player.bio != null) {
        _bioController.text = state.player.bio!;
        _characterCount = state.player.bio!.length;
      }
    }
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _bioController.text.length;
    });
    
    context.read<ProfileCreationCubit>().updateBio(_bioController.text);
  }

  void _updateCurrentStep() {
    // Esta etapa é opcional, então sempre marcamos como válida
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive && !state.isCurrentStepValid) {
      context.read<ProfileCreationCubit>().emit(state.copyWith(isCurrentStepValid: true));
    }
  }

  @override
  void dispose() {
    _bioController.removeListener(_updateCharacterCount);
    _bioController.dispose();
    super.dispose();
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
              'Conte-nos sobre você',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Escreva uma biografia curta descrevendo sua experiência e objetivos',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _bioController,
                maxLines: 7,
                maxLength: _maxBioLength,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 8),
                    child: Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(
                        color: currentLength >= _maxBioLength ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  );
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_maxBioLength),
                ],
                decoration: const InputDecoration(
                  hintText: 'Ex: Sou jogador de futsal há 10 anos, com experiência em competições universitárias. Tenho como objetivo me profissionalizar e representar a seleção brasileira.',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: const TextStyle(fontSize: 16),
                onChanged: (value) {
                  context.read<ProfileCreationCubit>().updateBio(value);
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Opcional: Esta é uma oportunidade para mostrar um pouco da sua personalidade e objetivos na carreira.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dicas para uma boa biografia:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTip('Mencione sua experiência no futsal'),
                  _buildTip('Descreva suas principais habilidades'),
                  _buildTip('Indique seus objetivos na carreira'),
                  _buildTip('Adicione conquistas relevantes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: Colors.blue),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 