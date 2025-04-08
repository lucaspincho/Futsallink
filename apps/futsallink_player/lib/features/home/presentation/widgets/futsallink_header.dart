import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class FutsallinkHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const FutsallinkHeader({
    Key? key,
    this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FutsallinkSpacing.md,
        vertical: FutsallinkSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo do Futsallink
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: FutsallinkColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  package: 'futsallink_ui',
                ),
              ),
              const SizedBox(width: FutsallinkSpacing.sm),
              Text(
                'Futsallink',
                style: FutsallinkTypography.headline1.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          // Ícone de configurações
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 28,
            ),
            onPressed: onSettingsTap,
          ),
        ],
      ),
    );
  }
} 