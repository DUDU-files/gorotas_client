import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/widgets/chat_card.dart';
import 'package:vans/providers/navigation_provider.dart';

class ChatContent extends StatefulWidget {
  const ChatContent({super.key});

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
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
    return SingleChildScrollView(
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
                  final navProvider = Provider.of<NavigationProvider>(
                    context,
                    listen: false,
                  );
                  navProvider.navigateTo(
                    AppScreen.privateChat,
                    title: chat['name'],
                    data: {'driverName': chat['name']},
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
    );
  }
}
