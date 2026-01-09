import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/widgets/chat_card.dart';
import 'package:vans/widgets/app_card.dart';
import 'package:vans/providers/navigation_provider.dart';
import 'package:vans/providers/chat_provider.dart';
import 'package:vans/providers/user_provider.dart';
import 'package:vans/models/chat_model.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    final userProvider = context.read<UserProvider>();
    final chatProvider = context.read<ChatProvider>();

    final clientId = userProvider.userId;
    if (clientId != null) {
      chatProvider.loadUserChats(clientId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final chats = chatProvider.chats;

        if (chats.isEmpty) {
          return const EmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'Nenhuma conversa ainda',
            subtitle: 'Suas conversas com motoristas aparecerão aqui',
          );
        }

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
                    name: chat.driverName,
                    lastMessage: chat.lastMessage,
                    lastMessageTime: chat.lastMessageTime,
                    unreadCount: chat.unreadCount,
                    isPinned: chat.isPinned,
                    onTap: () => _openChat(chat),
                    onPinnedChanged: (isPinned) {
                      // TODO: Implementar fixar conversa
                    },
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _openChat(ChatModel chat) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    navProvider.navigateTo(
      AppScreen.privateChat,
      title: chat.driverName,
      data: {
        'chatId': chat.id,
        'driverId': chat.driverId,
        'driverName': chat.driverName,
      },
    );
  }
}
