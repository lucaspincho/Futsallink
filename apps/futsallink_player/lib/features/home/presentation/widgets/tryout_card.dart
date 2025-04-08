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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(
          left: FutsallinkSpacing.md,
          bottom: FutsallinkSpacing.md,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Botão "Abertas"
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: FutsallinkColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Abertas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Conteúdo principal do card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo do clube
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: tryout.clubLogoUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(tryout.clubLogoUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: tryout.clubLogoUrl.isEmpty
                        ? const Icon(Icons.shield, color: Colors.white, size: 60)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Nome do clube
                  Text(
                    tryout.clubName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Categoria e posição
                  Text(
                    '${tryout.category} | ${tryout.position}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
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