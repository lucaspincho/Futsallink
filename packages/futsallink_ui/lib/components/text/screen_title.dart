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
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
