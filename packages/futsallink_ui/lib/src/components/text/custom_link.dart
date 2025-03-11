import 'package:flutter/material.dart';

class CustomLink extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Alignment? align; // ✅ Opcional: alinhamento personalizado

  const CustomLink({
    Key? key,
    required this.text,
    required this.onPressed,
    this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align, // Alinha o link conforme especificado
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove padding padrão
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
      ),
    );
  }
}