import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLogoHeader extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final double logoSize;
  final double iconSize;
  final double topPadding;
  final double bottomPadding; // ✅ Novo parâmetro para espaçamento inferior

  const CustomLogoHeader({
    this.showBackButton = false,
    this.onBackPressed,
    this.logoSize = 26.0,
    this.iconSize = 32.0,
    this.topPadding = 36.0,
    this.bottomPadding = 150.0, // ✅ Valor padrão para espaçamento inferior
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + topPadding,
        bottom: bottomPadding, // ✅ Aplica o espaçamento inferior padronizado
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo centralizado
          Center(
            child: SvgPicture.asset(
              'assets/logo.svg',
              height: logoSize,
              width: logoSize,
            ),
          ),
          
          // Seta posicionada extremamente à esquerda
          if (showBackButton)
            Positioned(
              left: 0,
              child: Padding(
                padding: EdgeInsets.zero,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back, 
                    size: iconSize, 
                    color: Colors.white
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: BoxConstraints(),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
