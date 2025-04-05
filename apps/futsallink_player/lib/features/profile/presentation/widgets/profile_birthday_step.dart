import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ProfileBirthdayStep extends StatefulWidget {
  const ProfileBirthdayStep({Key? key}) : super(key: key);

  @override
  State<ProfileBirthdayStep> createState() => _ProfileBirthdayStepState();
}

class _ProfileBirthdayStepState extends State<ProfileBirthdayStep> {
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive && state.player.birthday != null) {
      _selectedDate = state.player.birthday;
      _selectedDay = _selectedDate?.day;
      _selectedMonth = _selectedDate?.month;
      _selectedYear = _selectedDate?.year;
    }
  }

  void _updateDate() {
    if (_selectedDay != null && _selectedMonth != null && _selectedYear != null) {
      try {
        final newDate = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
        setState(() {
          _selectedDate = newDate;
        });
        context.read<ProfileCreationCubit>().updateBirthday(newDate);
      } catch (e) {
        // Data inválida, não atualiza
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usando a mesma estrutura do ProfileNameStep
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
                    text: 'QUAL SUA IDADE?',
                    bottomPadding: 8.0,
                  ),
                  
                  const SubtitleText(
                    text: 'Vamos usar sua data de nascimento pra encontrar as peneiras ideais pra você.',
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Seletores de data
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Campo Dia
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Dia',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomDropdownSelector<int>(
                              label: 'Dia',
                              value: _selectedDay,
                              items: List.generate(31, (index) => index + 1),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDay = value;
                                });
                                _updateDate();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        
                        // Campo Mês
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Mês',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomDropdownSelector<int>(
                              label: 'Mês',
                              value: _selectedMonth,
                              items: List.generate(12, (index) => index + 1),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMonth = value;
                                });
                                _updateDate();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        
                        // Campo Ano
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Ano',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomDropdownSelector<int>(
                              label: 'Ano',
                              value: _selectedYear,
                              items: List.generate(
                                DateTime.now().year - 1940 + 1,
                                (index) => DateTime.now().year - index,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedYear = value;
                                });
                                _updateDate();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Espaçamento extra no final (como no ProfileNameStep)
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}