import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';

class PrivateChatContent extends StatefulWidget {
  final Map<String, dynamic> data;

  const PrivateChatContent({super.key, required this.data});

  @override
  State<PrivateChatContent> createState() => _PrivateChatContentState();
}

class _PrivateChatContentState extends State<PrivateChatContent> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {'sender': 'driver', 'message': 'Bom dia', 'time': '07:00', 'type': 'text'},
    {
      'sender': 'user',
      'message': 'Comprei a passagem. Você ainda vai demorar pra chegar?',
      'time': '07:00',
      'type': 'text',
    },
    {
      'sender': 'driver',
      'message': 'Já estou a caminho, chego em uns 10 minutos!',
      'time': '07:02',
      'type': 'text',
    },
    {'sender': 'user', 'message': 'Ok!', 'time': '07:03', 'type': 'text'},
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'user',
          'message': _messageController.text,
          'time':
              '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          'type': 'text',
        });
        _messageController.clear();
      });
    }
  }

  void _sendAudio() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Áudio enviado!')));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlue,
      child: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == 'user';

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
                            message['message'],
                            style: TextStyle(
                              color: isUserMessage
                                  ? AppColors.white
                                  : AppColors.primaryBlue,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['time'],
                            style: TextStyle(
                              color: isUserMessage
                                  ? AppColors.white.withOpacity(0.8)
                                  : AppColors.primaryBlue.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
