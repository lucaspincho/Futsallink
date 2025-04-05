import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ProfileHeightWeightStep extends StatefulWidget {
  const ProfileHeightWeightStep({Key? key}) : super(key: key);

  @override
  State<ProfileHeightWeightStep> createState() => _ProfileHeightWeightStepState();
}

class _ProfileHeightWeightStepState extends State<ProfileHeightWeightStep> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get isValid {
    if (_formKey.currentState?.validate() ?? false) {
      final height = int.tryParse(_heightController.text);
      final weight = double.tryParse(_weightController.text);
      return height != null && height > 0 && weight != null && weight > 0;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      if (state.player.height > 0) {
        _heightController.text = state.player.height.toString();
      }
      if (state.player.weight > 0) {
        _weightController.text = state.player.weight.toString();
      }
    }
  }

  void _updatePlayerInfo() {
    if (isValid) {
      final height = int.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      
      context.read<ProfileCreationCubit>().updateHeight(height);
      context.read<ProfileCreationCubit>().updateWeight(weight);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
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
                onChanged: _updatePlayerInfo,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ScreenTitle(
                      text: 'QUAL SUA ALTURA E PESO?',
                      bottomPadding: 8.0,
                    ),
                    
                    const SubtitleText(
                      text: 'Informe seus dados físicos para completar seu perfil.',
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Campo de altura
                    CustomTextField(
                      hintText: 'Altura (cm)*',
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      suffixIcon: Container(
                        padding: const EdgeInsets.only(right: 24.0),
                        alignment: Alignment.center,
                        width: 40,
                        child: const Text(
                          'cm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Altura é obrigatória';
                        }
                        
                        final height = int.tryParse(value);
                        if (height == null) {
                          return 'Digite um número válido';
                        }
                        
                        if (height < 100 || height > 250) {
                          return 'Altura deve estar entre 100 e 250 cm';
                        }
                        
                        return null;
                      },
                      onChanged: (value) => _updatePlayerInfo(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Campo de peso
                    CustomTextField(
                      hintText: 'Peso (kg)*',
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      suffixIcon: Container(
                        padding: const EdgeInsets.only(right: 24.0),
                        alignment: Alignment.center,
                        width: 40,
                        child: const Text(
                          'kg',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Peso é obrigatório';
                        }
                        
                        final weight = double.tryParse(value);
                        if (weight == null) {
                          return 'Digite um número válido';
                        }
                        
                        if (weight < 30 || weight > 200) {
                          return 'Peso deve estar entre 30 e 200 kg';
                        }
                        
                        return null;
                      },
                      onChanged: (value) => _updatePlayerInfo(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Nota sobre campos obrigatórios
                    Text(
                      '* Campos obrigatórios',
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