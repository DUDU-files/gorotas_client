import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  ChatModel? _currentChat;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  ChatModel? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carrega as conversas do usuário
  void loadUserChats(String clientId) {
    _chatService
        .getUserChatsStream(clientId)
        .listen(
          (chatList) {
            _chats = chatList;
            notifyListeners();
          },
          onError: (e) {
            _error = 'Erro ao carregar conversas';
            notifyListeners();
          },
        );
  }

  /// Abre ou cria uma conversa com um motorista
  Future<ChatModel> openChat({
    required String clientId,
    required String driverId,
    required String driverName,
    String? driverPhoto,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final chat = await _chatService.getOrCreateChat(
        clientId: clientId,
        driverId: driverId,
        driverName: driverName,
        driverPhoto: driverPhoto,
      );

      _currentChat = chat;
      _isLoading = false;
      notifyListeners();

      return chat;
    } catch (e) {
      _isLoading = false;
      _error = 'Erro ao abrir conversa';
      notifyListeners();
      rethrow;
    }
  }

  /// Carrega mensagens de um chat em tempo real
  void loadChatMessages(String chatId) {
    _messages = [];
    notifyListeners();

    _chatService
        .getChatMessagesStream(chatId)
        .listen(
          (messageList) {
            _messages = messageList;
            notifyListeners();
          },
          onError: (e) {
            _error = 'Erro ao carregar mensagens';
            notifyListeners();
          },
        );
  }

  /// Envia uma mensagem
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderType,
    required String message,
    String type = 'text',
  }) async {
    try {
      await _chatService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        senderType: senderType,
        message: message,
        type: type,
      );
    } catch (e) {
      _error = 'Erro ao enviar mensagem';
      notifyListeners();
      rethrow;
    }
  }

  /// Marca mensagens como lidas
  Future<void> markAsRead(String chatId, String readerId) async {
    await _chatService.markMessagesAsRead(chatId, readerId);
  }

  /// Deleta uma conversa
  Future<void> deleteChat(String chatId) async {
    try {
      await _chatService.deleteChat(chatId);
      _chats.removeWhere((chat) => chat.id == chatId);
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao deletar conversa';
      notifyListeners();
      rethrow;
    }
  }

  /// Limpa o chat atual
  void clearCurrentChat() {
    _currentChat = null;
    _messages = [];
    notifyListeners();
  }

  /// Limpa erros
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Conta mensagens não lidas
  int get totalUnreadCount {
    return _chats.fold(0, (sum, chat) => sum + chat.unreadCount);
  }
}
