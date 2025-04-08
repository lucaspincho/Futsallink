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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: club.logoUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(club.logoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: club.logoUrl.isEmpty
                ? const Icon(Icons.shield, color: Colors.white, size: 40)
                : null,
          ),
        ),
      ),
    );
  }
} 