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
        left: FutsallinkSpacing.md,
        right: FutsallinkSpacing.md,
        top: FutsallinkSpacing.xl,
        bottom: FutsallinkSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: FutsallinkTypography.headline1.copyWith(
              color: Colors.white,
            ),
          ),
          if (onSeeMoreTap != null)
            GestureDetector(
              onTap: onSeeMoreTap,
              child: Row(
                children: [
                  Text(
                    'Ver mais',
                    style: FutsallinkTypography.subtitle1.copyWith(
                      color: FutsallinkColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: FutsallinkColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 