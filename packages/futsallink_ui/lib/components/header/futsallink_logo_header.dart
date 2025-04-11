import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FutsallinkLogoHeader extends StatelessWidget {
  final double logoHeight;
  final double verticalPadding;

  const FutsallinkLogoHeader({
    Key? key,
    this.logoHeight = 32.0,
    this.verticalPadding = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          height: logoHeight,
          // package: 'futsallink_ui',
        ),
      ),
    );
  }
} 