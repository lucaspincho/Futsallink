import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:intl/intl.dart';

class ProfileBirthdayStep extends StatefulWidget {
  const ProfileBirthdayStep({Key? key}) : super(key: key);

  @override
  State<ProfileBirthdayStep> createState() => _ProfileBirthdayStepState();
}

class _ProfileBirthdayStepState extends State<ProfileBirthdayStep> {
  final _birthdayController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      _selectedDate = state.player.birthday;
      _birthdayController.text = _dateFormat.format(_selectedDate!);
      
      // Atualiza o estado caso a data já seja válida
      if (_selectedDate != null) {
        context.read<ProfileCreationCubit>().updateBirthday(_selectedDate!);
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
      fieldLabelText: 'Data de nascimento',
      fieldHintText: 'DD/MM/AAAA',
      errorFormatText: 'Insira uma data válida',
      errorInvalidText: 'Insira uma data dentro do intervalo válido',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = _dateFormat.format(picked);
        context.read<ProfileCreationCubit>().updateBirthday(picked);
      });
    }
  }

  @override
  void dispose() {
    _birthdayController.dispose();
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
              'Qual é a sua data de nascimento?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sua idade é um dado importante para clubes e olheiros',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            BlocBuilder<ProfileCreationCubit, ProfileCreationState>(
              builder: (context, state) {
                if (state is ProfileCreationActive) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _birthdayController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento *',
                          hintText: 'DD/MM/AAAA',
                          prefixIcon: const Icon(Icons.calendar_today),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.edit_calendar),
                            onPressed: _selectDate,
                          ),
                        ),
                        onTap: _selectDate,
                      ),
                      const SizedBox(height: 24),
                      if (_selectedDate != null)
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
                              Expanded(
                                child: Text(
                                  'Sua idade: ${state.player.age} anos',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      const Text(
                        '* Campo obrigatório',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
} 