import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class FutsallinkHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final bool isHomePage;

  const FutsallinkHeader({
    Key? key,
    this.onSettingsTap,
    this.isHomePage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Versão específica para a Home, seguindo o design do Figma
    if (isHomePage) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          FutsallinkSpacing.lg,
          FutsallinkSpacing.xl,
          FutsallinkSpacing.lg,
          FutsallinkSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo do Futsallink
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: FutsallinkColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    package: 'futsallink_ui',
                  ),
                ),
                const SizedBox(width: FutsallinkSpacing.sm),
                Text(
                  'Futsallink',
                  style: FutsallinkTypography.headline2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            
            // Ícone de configurações
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                onPressed: onSettingsTap,
              ),
            ),
          ],
        ),
      );
    }
    
    // Versão original para outras telas do app
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
                width: 36,
                height: 36,
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
                style: FutsallinkTypography.headline2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          // Ícone de configurações
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 24,
            ),
            onPressed: onSettingsTap,
          ),
        ],
      ),
    );
  }
} 