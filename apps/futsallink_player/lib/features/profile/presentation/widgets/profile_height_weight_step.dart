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
                'Qual é a sua altura e peso?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Informe seus dados físicos para completar seu perfil',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Altura (cm) *',
                  hintText: 'Ex: 175',
                  prefixIcon: Icon(Icons.height),
                  suffixText: 'cm',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
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
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg) *',
                  hintText: 'Ex: 70.5',
                  prefixIcon: Icon(Icons.line_weight),
                  suffixText: 'kg',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                  LengthLimitingTextInputFormatter(5),
                ],
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Estas informações são importantes para os clubes avaliarem seu perfil físico.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 