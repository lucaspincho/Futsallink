import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ProfileTeamStep extends StatefulWidget {
  const ProfileTeamStep({Key? key}) : super(key: key);

  @override
  State<ProfileTeamStep> createState() => _ProfileTeamStepState();
}

class _ProfileTeamStepState extends State<ProfileTeamStep> {
  final _teamController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeField();
  }

  void _initializeField() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      if (state.player.currentTeam != null && state.player.currentTeam!.isNotEmpty) {
        _teamController.text = state.player.currentTeam!;
        
        // Atualiza o estado caso o time já esteja preenchido
        _updateTeam();
      }
    }
  }

  void _updateTeam() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileCreationCubit>().updateCurrentTeam(_teamController.text.trim());
    }
  }

  @override
  void dispose() {
    _teamController.dispose();
    super.dispose();
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
              child: Form(
                key: _formKey,
                onChanged: _updateTeam,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ScreenTitle(
                      text: 'QUAL SEU TIME?',
                      bottomPadding: 8.0,
                    ),
                    
                    const SubtitleText(
                      text: 'Infome-nos o seu time atual. Caso não esteja em nenhum clube, não marque a opção e aperte em avançar.',
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Campo de time
                    CustomTextField(
                      hintText: 'Nome do Time*',
                      controller: _teamController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'O nome do time é obrigatório';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Texto de ajuda
                    Text(
                      'Caso não esteja vinculado a nenhum time no momento, digite "Sem clube"',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    
                    const SizedBox(height: 24),                    
                    
                    // Nota sobre campos obrigatórios
                    Text(
                      '* Campo obrigatório',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    
                    // Espaçamento extra no final (como nas outras telas)
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 