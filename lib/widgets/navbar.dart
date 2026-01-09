import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/exports.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const Navbar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final unreadCount = chatProvider.totalUnreadCount;

        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onItemSelected,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.primaryBlue,
          selectedItemColor: AppColors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Passagens',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: AppColors.primaryOrange,
                child: const Icon(Icons.chat_bubble_outline),
              ),
              label: 'Conversas',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
        );
      },
    );
  }
}
