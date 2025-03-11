import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

class FutsallinkClubCard extends StatelessWidget {
  final String clubName;
  final String category;
  final String position;
  final String? logoUrl;
  final VoidCallback? onTap;
  final bool hasOpenTryouts;
  
  const FutsallinkClubCard({
    super.key,  // Use super para o key - isso resolve o problema de "super parameter"
    required this.clubName,
    required this.category,
    required this.position,
    this.logoUrl,
    this.onTap,
    this.hasOpenTryouts = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Logo do clube
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: logoUrl != null
                    ? DecorationImage(image: NetworkImage(logoUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: logoUrl == null ? const Icon(Icons.shield, color: Colors.white) : null,
            ),
            const SizedBox(width: 16),
            // Informações do clube
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clubName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$category | $position',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),  // Use .withOpacity - apesar do aviso, é o mais comum
                    ),
                  ),
                ],
              ),
            ),
            // Indicador de seletivas abertas
            if (hasOpenTryouts)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: FutsallinkColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Abertas',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}