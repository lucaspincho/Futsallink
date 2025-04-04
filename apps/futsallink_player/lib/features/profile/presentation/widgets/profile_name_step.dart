import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_ui/tokens/spacing.dart';
import 'package:futsallink_ui/components/buttons/primary_button.dart';

class ProfileNameStep extends StatefulWidget {
  const ProfileNameStep({Key? key}) : super(key: key);

  @override
  State<ProfileNameStep> createState() => _ProfileNameStepState();
}

class _ProfileNameStepState extends State<ProfileNameStep> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      _firstNameController.text = state.player.firstName;
      _lastNameController.text = state.player.lastName;
      _nicknameController.text = state.player.nickname ?? '';
    }
  }

  void _updatePlayerInfo() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileCreationCubit>().updateName(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _nicknameController.text.trim().isEmpty
                ? null
                : _nicknameController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updatePlayerInfo,
      child: LayoutBuilder(
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
                      text: 'QUEM É VOCÊ?',
                      bottomPadding: 8.0,
                    ),

                    const SizedBox(height: 48),

                    // Campos de entrada
                    CustomTextField(
                      controller: _firstNameController,
                      hintText: 'Nome*',
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: _lastNameController,
                      hintText: 'Sobrenome*',
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Sobrenome é obrigatório';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: _nicknameController,
                      hintText: 'Apelido (Opcional)',
                      textCapitalization: TextCapitalization.words,
                    ),

                    // Espaçamento extra antes do botão (que é adicionado pelo widget pai)
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
