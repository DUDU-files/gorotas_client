import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/screens/chat.dart';
import 'package:vans/screens/tickets.dart';
import 'package:vans/screens/search.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const BottomMenu({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  void _handleMenuTap(BuildContext context, int index) {
    onItemSelected(index);

    if (index == 0) {
      // Buscar
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      });
    } else if (index == 2) {
      // Conversas
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      });
    } else if (index == 1) {
      // Passagens
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TicketsScreen()),
        );
      });
    } else if (index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tela de Menu em desenvolvimento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MenuItem(
            icon: Icons.search,
            label: 'Buscar',
            isSelected: currentIndex == 0,
            onTap: () => _handleMenuTap(context, 0),
          ),
          _MenuItem(
            icon: Icons.receipt,
            label: 'Passagens',
            isSelected: currentIndex == 1,
            onTap: () => _handleMenuTap(context, 1),
          ),
          _MenuItem(
            icon: Icons.chat_bubble_outline,
            label: 'Conversas',
            isSelected: currentIndex == 2,
            onTap: () => _handleMenuTap(context, 2),
          ),
          _MenuItem(
            icon: Icons.menu,
            label: 'Menu',
            isSelected: currentIndex == 3,
            onTap: () => _handleMenuTap(context, 3),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.white : Colors.white70,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : Colors.white70,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


