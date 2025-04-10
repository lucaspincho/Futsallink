import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../../domain/models/club_model.dart';

class ClubGridItem extends StatelessWidget {
  final ClubModel club;
  final VoidCallback? onTap;

  const ClubGridItem({
    Key? key,
    required this.club,
    this.onTap,
  }) : super(key: key);

  // Função para obter o caminho da imagem do escudo com base no nome do clube
  String _getClubLogoPath(String clubName) {
    final clubNameLower = clubName.toLowerCase();
    
    if (clubNameLower.contains('sport')) {
      return '../../assets/images/escudos/sport.png';
    } else if (clubNameLower.contains('corinthians')) {
      return '../../assets/images/escudos/corinthians.png';
    } else if (clubNameLower.contains('américa') || clubNameLower.contains('america')) {
      return '../../assets/images/escudos/america_mineiro.png';
    } else if (clubNameLower.contains('náutico') || clubNameLower.contains('nautico')) {
      return '../../assets/images/escudos/nautico.png';
    } else if (clubNameLower.contains('bahia')) {
      return '../../assets/images/escudos/bahia.png';
    } else if (clubNameLower.contains('santa cruz')) {
      return '../../assets/images/escudos/santa_cruz.png';
    } else if (clubNameLower.contains('joinville')) {
      return '../../assets/images/escudos/joinville.png';
    } else if (clubNameLower.contains('goiás') || clubNameLower.contains('goias')) {
      return '../../assets/images/escudos/goias.png';
    } else if (clubNameLower.contains('atlântico') || clubNameLower.contains('atlantico')) {
      return '../../assets/images/escudos/atlantico_erechim.png';
    }
    
    // Escudo padrão se não encontrar correspondência
    return '../../assets/images/escudos/sport.png';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                _getClubLogoPath(club.name),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}