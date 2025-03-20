import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          onChanged: _updatePlayerInfo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Como você se chama?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Digite seu nome completo para que todos possam te identificar',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  hintText: 'Ex: João',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Sobrenome *',
                  hintText: 'Ex: Silva',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Sobrenome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Apelido (opcional)',
                  hintText: 'Ex: Jota',
                  prefixIcon: Icon(Icons.badge),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),
              const Text(
                '* Campos obrigatórios',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 