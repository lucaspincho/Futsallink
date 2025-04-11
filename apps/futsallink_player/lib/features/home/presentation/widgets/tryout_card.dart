import 'dart:math';

import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../../domain/models/tryout_model.dart';

class TryoutCard extends StatelessWidget {
  final TryoutModel tryout;
  final VoidCallback? onTap;

  const TryoutCard({
    Key? key,
    required this.tryout,
    this.onTap,
  }) : super(key: key);

  // Função para obter o caminho da imagem do escudo com base no nome do clube
  String _getClubLogoPath(String clubName) {
    final clubNameLower = clubName.toLowerCase();
    
    if (clubNameLower.contains('sport')) {
      return 'assets/images/escudos/sport.png';
    } else if (clubNameLower.contains('corinthians')) {
      return 'assets/images/escudos/corinthians.png';
    } else if (clubNameLower.contains('américa') || clubNameLower.contains('america')) {
      return 'assets/images/escudos/america_mineiro.png';
    } else if (clubNameLower.contains('náutico') || clubNameLower.contains('nautico')) {
      return 'assets/images/escudos/nautico.png';
    } else if (clubNameLower.contains('bahia')) {
      return 'assets/images/escudos/bahia.png';
    } else if (clubNameLower.contains('santa cruz')) {
      return 'assets/images/escudos/santa_cruz.png';
    } else if (clubNameLower.contains('joinville')) {
      return 'assets/images/escudos/joinville.png';
    } else if (clubNameLower.contains('goiás') || clubNameLower.contains('goias')) {
      return 'assets/images/escudos/goias.png';
    } else if (clubNameLower.contains('atlântico') || clubNameLower.contains('atlantico')) {
      return 'assets/images/escudos/atlantico_erechim.png';
    }
    
    // Escudo padrão se não encontrar correspondência
    return 'assets/images/escudos/sport.png';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 230,
        margin: const EdgeInsets.only(
          left: FutsallinkSpacing.lg,
          bottom: FutsallinkSpacing.md,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: 0.15,
                  child: CustomPaint(
                    painter: HexagonPatternPainter(
                      color: Colors.white.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            
            // Botão "Abertas"
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: FutsallinkColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: FutsallinkColors.primary.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Abertas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            
            // Conteúdo principal do card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo do clube
                  Container(
                    width: 90,
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Image.asset(
                        _getClubLogoPath(tryout.clubName),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  // Nome do clube
                  Text(
                    tryout.clubName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: FutsallinkTypography.subtitle1.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Categoria e posição
                  Text(
                    '${tryout.category} | ${tryout.position}',
                    textAlign: TextAlign.center,
                    style: FutsallinkTypography.body2.copyWith(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexagonPatternPainter extends CustomPainter {
  final Color color;
  final double size;

  HexagonPatternPainter({
    required this.color,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double hexWidth = this.size;
    final double hexHeight = this.size * 0.866; // sqrt(3)/2

    for (double y = -hexHeight; y < size.height + hexHeight; y += hexHeight * 1.5) {
      for (double x = -hexWidth; x < size.width + hexWidth; x += hexWidth * 3) {
        drawHexagon(canvas, paint, Offset(x, y), hexWidth / 2);
        drawHexagon(canvas, paint, Offset(x + hexWidth * 1.5, y + hexHeight * 0.75), hexWidth / 2);
      }
    }
  }

  void drawHexagon(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;
      final double x = center.dx + radius * cos(angle);
      final double y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 