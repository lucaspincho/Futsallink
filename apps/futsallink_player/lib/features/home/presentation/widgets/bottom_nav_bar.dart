import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

enum NavItem {
  home,
  tryouts,
  clubs,
  chat,
  profile,
}

class BottomNavBar extends StatelessWidget {
  final NavItem currentItem;
  final Function(NavItem) onItemSelected;

  const BottomNavBar({
    Key? key,
    required this.currentItem,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: FutsallinkColors.darkBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            NavItem.home,
            'Início',
            Icons.home,
          ),
          _buildNavItem(
            context,
            NavItem.tryouts,
            'Seletivas',
            Icons.sports_soccer,
          ),
          _buildNavItem(
            context,
            NavItem.clubs,
            'Clubes',
            Icons.shield,
          ),
          _buildNavItem(
            context,
            NavItem.chat,
            'Chat',
            Icons.chat_bubble,
          ),
          _buildNavItem(
            context,
            NavItem.profile,
            'Perfil',
            Icons.person,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavItem item,
    String label,
    IconData icon,
  ) {
    final isSelected = currentItem == item;
    final color = isSelected ? FutsallinkColors.primary : Colors.grey;

    return InkWell(
      onTap: () {
        if (item != currentItem) {
          if (item == NavItem.clubs) {
            Navigator.pushNamed(context, '/clubs');
            return;
          }
          
          onItemSelected(item);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 