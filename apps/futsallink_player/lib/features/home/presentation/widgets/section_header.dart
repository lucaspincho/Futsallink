import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMoreTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onSeeMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: FutsallinkSpacing.lg,
        right: FutsallinkSpacing.lg,
        top: 32.0,
        bottom: FutsallinkSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: FutsallinkTypography.headline3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          if (onSeeMoreTap != null)
            GestureDetector(
              onTap: onSeeMoreTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FutsallinkSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      'Ver mais',
                      style: FutsallinkTypography.button.copyWith(
                        color: FutsallinkColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: FutsallinkColors.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
} 