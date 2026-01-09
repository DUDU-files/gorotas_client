import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/exports.dart';

class PrivateChat extends StatefulWidget {
  final Map<String, dynamic> data;

  const PrivateChat({super.key, required this.data});

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatModel? _chat;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final userProvider = context.read<UserProvider>();
    final chatProvider = context.read<ChatProvider>();

    final clientId = userProvider.userId ?? '';
    final driverId = widget.data['driverId'] ?? '';
    final driverName = widget.data['driverName'] ?? 'Motorista';

    if (clientId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Abre ou cria o chat
      final chat = await chatProvider.openChat(
        clientId: clientId,
        driverId: driverId,
        driverName: driverName,
      );

      setState(() {
        _chat = chat;
        _isLoading = false;
      });

      // Carrega as mensagens em tempo real
      chatProvider.loadChatMessages(chat.id);

      // Marca mensagens como lidas
      chatProvider.markAsRead(chat.id, clientId);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _chat == null) return;

    final userProvider = context.read<UserProvider>();
    final chatProvider = context.read<ChatProvider>();
    final clientId = userProvider.userId ?? '';

    chatProvider.sendMessage(
      chatId: _chat!.id,
      senderId: clientId,
      senderType: 'client',
      message: _messageController.text.trim(),
    );

    _messageController.clear();

    // Scroll para o final
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendAudio() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função de áudio em desenvolvimento!')),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: AppColors.primaryBlue,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.white),
        ),
      );
    }

    if (_chat == null) {
      return Container(
        color: AppColors.primaryBlue,
        child: const Center(
          child: Text(
            'Erro ao carregar conversa',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.primaryBlue,
      child: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                final messages = chatProvider.messages;

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhuma mensagem ainda.\nInicie a conversa!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message.senderType == 'client';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? AppColors.primaryOrange
                                : AppColors.secondaryBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: isUserMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isUserMessage
                                      ? AppColors.white
                                      : AppColors.primaryBlue,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    message.formattedTime,
                                    style: TextStyle(
                                      color: isUserMessage
                                          ? AppColors.white.withOpacity(0.8)
                                          : AppColors.primaryBlue.withOpacity(
                                              0.6,
                                            ),
                                      fontSize: 11,
                                    ),
                                  ),
                                  if (isUserMessage) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      message.isRead
                                          ? Icons.done_all
                                          : Icons.done,
                                      size: 14,
                                      color: AppColors.white.withOpacity(0.8),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input de mensagem
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // Campo de texto
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem',
                      hintStyle: const TextStyle(color: AppColors.primaryGray),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: AppColors.backgroudGray,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Botão de áudio
                GestureDetector(
                  onTap: _sendAudio,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Botão de enviar
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
