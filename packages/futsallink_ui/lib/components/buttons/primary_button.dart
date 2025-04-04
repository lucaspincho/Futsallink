import 'package:flutter/material.dart';
import 'package:futsallink_ui/tokens/colors.dart';
import 'package:futsallink_ui/tokens/typography.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color activeColor;
  final Color disabledColor;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.activeColor = FutsallinkColors.primary,
    this.disabledColor = const Color(0xFF9E9E9E),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? activeColor : disabledColor,
          elevation: 2,
          side: BorderSide(
            color: onPressed == null 
                ? Colors.grey.withOpacity(0.5)
                : Colors.transparent,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text.toUpperCase(),
                style: UnboundedFont.bold(
                  size: 18,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }
}