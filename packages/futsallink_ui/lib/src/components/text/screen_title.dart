import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String text;
  final double bottomPadding;

  const ScreenTitle({
    Key? key,
    required this.text,
    this.bottomPadding = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( // ✅ Novo Container para forçar largura total
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center, // Mantém o alinhamento central
        ),
      ),
    );
  }
}
