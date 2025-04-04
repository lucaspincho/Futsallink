import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futsallink_ui/tokens/colors.dart';

class CustomNumericField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomNumericField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.number,
    this.prefixIcon,
    this.suffixText,
    this.inputFormatters,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          prefixIcon: prefixIcon,
          suffixText: suffixText,
          suffixStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          errorStyle: TextStyle(
            color: FutsallinkColors.error,
            fontSize: 13,
          ),
        ),
        validator: validator,
      ),
    );
  }
} 