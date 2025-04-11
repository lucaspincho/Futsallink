import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_player/features/home/domain/models/tryout_model.dart';

class TryoutGridItem extends StatelessWidget {
  final TryoutModel tryout;
  final VoidCallback? onTap;
  final int inscritosCount;

  const TryoutGridItem({
    Key? key,
    required this.tryout,
    this.onTap,
    this.inscritosCount = 12,
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
        width: 180,
        margin: const EdgeInsets.only(right: FutsallinkSpacing.md),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(16),
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/pattern_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            // Conteúdo do card
            Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row com botão "Abertas" e contagem de inscritos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão "Abertas"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: FutsallinkColors.primary,
                          borderRadius: BorderRadius.circular(12),
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // Espaçamento flexível
                      const SizedBox(width: 4),
                      
                      // Contagem de inscritos
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '$inscritosCount inscritos',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Logo do clube
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        _getClubLogoPath(tryout.clubName),
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Nome do clube
                  Text(
                    tryout.clubName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Categoria e posição
                  Text(
                    '${tryout.category} | ${tryout.position}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
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