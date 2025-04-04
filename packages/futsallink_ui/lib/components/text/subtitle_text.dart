import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  final String text;

  const SubtitleText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.grey[400]),
        textAlign: TextAlign.center, // Para manter alinhado como nos seus designs
      ),
    );
  }
}
