import 'package:flutter/material.dart';
import 'package:futsallink_ui/widgets/widgets.dart';
import 'package:futsallink_player/core/routes.dart';

class ProfileAgeScreen extends StatefulWidget {
  @override
  _ProfileAgeScreenState createState() => _ProfileAgeScreenState();
}

class _ProfileAgeScreenState extends State<ProfileAgeScreen> {
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  final List<String> _days =
      List.generate(31, (index) => (index + 1).toString());
  final List<String> _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];
  late final List<String> _years = List.generate(
          DateTime.now().year - 1930 + 1, (index) => (1930 + index).toString())
      .reversed
      .toList();

  bool get _isFormValid =>
      _selectedDay != null && _selectedMonth != null && _selectedYear != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1A2A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomLogoHeader(
              showBackButton: true,
            ),
            ScreenTitle(text: "QUAL SUA IDADE?"),
            SubtitleText(
              text:
                  "Informe sua data de nascimento abaixo. Sua idade nos ajudará a indicar seletivas perfeitas para você.",
            ),
            SizedBox(height: 50),
            _buildDateDropdowns(),
            SizedBox(height: 80),
            PrimaryButton(
              text: "AVANÇAR",
              onPressed: _isFormValid
                  ? () => Navigator.pushNamed(context, '/proxima-tela')
                  : null, // ✅ onPressed = null quando inválido
              activeColor: Color(0xFF1877F2),
              disabledColor: Color(0xFF9E9E9E), // Corrigido para cinza claro
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDateDropdowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _buildDateDropdown(
            hint: "Dia",
            items: _days,
            value: _selectedDay,
            onChanged: (v) => setState(() => _selectedDay = v),
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: _buildDateDropdown(
            hint: "Mês",
            items: _months,
            value: _selectedMonth,
            onChanged: (v) => setState(() => _selectedMonth = v),
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: _buildDateDropdown(
            hint: "Ano",
            items: _years,
            value: _selectedYear,
            onChanged: (v) => setState(() => _selectedYear = v),
          ),
        ),
      ],
    );
  }

  Widget _buildDateDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
          dropdownColor: Color(0xFF1A2A3A),
          style: TextStyle(color: Colors.white, fontSize: 16),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          items: items.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
