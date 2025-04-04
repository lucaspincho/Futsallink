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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const ScreenTitle(
              text: 'QUAL SUA IDADE?',
              bottomPadding: 8.0,
            ),
            const SubtitleText(
              text: 'Informe sua data de nascimento abaixo.\nSua idade nos ajudará a indicar seletivas perfeitas para você.',
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo Dia
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
                const SizedBox(width: 16),
                // Campo Mês
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
                const SizedBox(width: 16),
                // Campo Ano
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
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
} 