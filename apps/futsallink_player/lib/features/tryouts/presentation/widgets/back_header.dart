import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class BackHeader extends StatelessWidget {
  final VoidCallback? onBackTap;

  const BackHeader({
    Key? key,
    this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FutsallinkSpacing.md,
        FutsallinkSpacing.xl,
        FutsallinkSpacing.md,
        FutsallinkSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Botão de voltar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              onPressed: onBackTap ?? () => Navigator.of(context).pop(),
            ),
          ),
          
          // Logo do Futsallink
          SvgPicture.asset(
            'assets/images/logo.svg',
            height: 24,
            fit: BoxFit.contain,
          ),
          
          // Espaço para equilibrar o layout
          const SizedBox(width: 40),
        ],
      ),
    );
  }
} 