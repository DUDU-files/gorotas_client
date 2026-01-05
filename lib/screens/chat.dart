import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/bottom_menu.dart';
import 'package:vans/widgets/chat_card.dart';
import 'package:vans/screens/private_chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedMenuIndex = 2;

  // Dados de exemplo para os chats
  final List<Map<String, dynamic>> chats = [
    {
      'name': 'João Gomes',
      'rating': 4.8,
      'trips': 156,
      'memberSince': 'Janeiro de 2025',
      'isPinned': false,
    },
    {
      'name': 'Nathan',
      'rating': 4.8,
      'trips': 156,
      'memberSince': 'Janeiro de 2025',
      'isPinned': false,
    },
    {
      'name': 'Tarcísio',
      'rating': 4.8,
      'trips': 156,
      'memberSince': 'Janeiro de 2025',
      'isPinned': false,
    },
    {
      'name': 'Zé Vaqueiro',
      'rating': 4.8,
      'trips': 156,
      'memberSince': 'Janeiro de 2025',
      'isPinned': false,
    },
    {
      'name': 'Léo Foguete',
      'rating': 4.8,
      'trips': 156,
      'memberSince': 'Janeiro de 2025',
      'isPinned': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroudGray,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.directions_bus,
                      size: 24,
                      color: AppColors.primaryBlue,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Conversas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatCard(
                  name: chat['name'],
                  rating: chat['rating'],
                  trips: chat['trips'],
                  memberSince: chat['memberSince'],
                  isPinned: chat['isPinned'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivateChatScreen(
                          driverName: chat['name'],
                        ),
                      ),
                    );
                  },
                  onPinnedChanged: (isPinned) {
                    setState(() {
                      chat['isPinned'] = isPinned;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedMenuIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedMenuIndex = index;
          });
        },
      ),
    );
  }
}
