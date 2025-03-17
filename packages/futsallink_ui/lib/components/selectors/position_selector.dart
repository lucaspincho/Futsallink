import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

class FutsallinkPositionSelector extends StatelessWidget {
  final String position;
  final bool isSelected;
  final VoidCallback onTap;
  
  const FutsallinkPositionSelector({
    super.key,
    required this.position,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? FutsallinkColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? FutsallinkColors.primary : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check, color: Colors.white, size: 18),
            if (isSelected)
              const SizedBox(width: 4),
            Text(
              position,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}