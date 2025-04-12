import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_player/features/home/domain/models/tryout_model.dart';

class TryoutListItem extends StatelessWidget {
  final TryoutModel tryout;
  final VoidCallback? onTap;

  const TryoutListItem({
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Escudo do clube
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Center(
                  child: Image.asset(
                    _getClubLogoPath(tryout.clubName),
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Detalhes do clube
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      '${tryout.category} | ${tryout.position}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botão "Abertas"
              Container(
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 