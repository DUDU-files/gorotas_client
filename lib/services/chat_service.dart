import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Coleções
  CollectionReference get _chatsCollection => _firestore.collection('chats');
  CollectionReference get _messagesCollection =>
      _firestore.collection('messages');

  /// Busca ou cria um chat entre cliente e motorista
  Future<ChatModel> getOrCreateChat({
    required String clientId,
    required String driverId,
    required String driverName,
    String? driverPhoto,
  }) async {
    try {
      // Busca chat existente entre cliente e motorista
      final querySnapshot = await _chatsCollection
          .where('clientId', isEqualTo: clientId)
          .where('driverId', isEqualTo: driverId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Chat já existe, retorna ele
        final doc = querySnapshot.docs.first;
        return ChatModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }

      // Cria novo chat
      final chatData = {
        'clientId': clientId,
        'driverId': driverId,
        'driverName': driverName,
        'driverPhoto': driverPhoto,
        'lastMessage': null,
        'lastMessageTime': null,
        'unreadCount': 0,
        'isPinned': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _chatsCollection.add(chatData);

      return ChatModel(
        id: docRef.id,
        clientId: clientId,
        driverId: driverId,
        driverName: driverName,
        driverPhoto: driverPhoto,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Erro ao criar/buscar chat: $e');
    }
  }

  /// Envia uma mensagem
  Future<MessageModel> sendMessage({
    required String chatId,
    required String senderId,
    required String senderType,
    required String message,
    String type = 'text',
  }) async {
    try {
      final messageData = {
        'chatId': chatId,
        'senderId': senderId,
        'senderType': senderType,
        'message': message,
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      // Adiciona a mensagem
      final docRef = await _messagesCollection.add(messageData);

      // Atualiza o último mensagem do chat
      // Só incrementa unreadCount se for mensagem do motorista (para o cliente ver)
      if (senderType == 'driver') {
        await _chatsCollection.doc(chatId).update({
          'lastMessage': message,
          'lastMessageTime': FieldValue.serverTimestamp(),
          'unreadCount': FieldValue.increment(1),
        });
      } else {
        await _chatsCollection.doc(chatId).update({
          'lastMessage': message,
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      }

      return MessageModel(
        id: docRef.id,
        chatId: chatId,
        senderId: senderId,
        senderType: senderType,
        message: message,
        type: type,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Erro ao enviar mensagem: $e');
    }
  }

  /// Stream de mensagens em tempo real
  Stream<List<MessageModel>> getChatMessagesStream(String chatId) {
    return _messagesCollection
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  /// Busca todas as conversas do usuário
  Stream<List<ChatModel>> getUserChatsStream(String clientId) {
    return _chatsCollection
        .where('clientId', isEqualTo: clientId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChatModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  /// Marca mensagens como lidas
  Future<void> markMessagesAsRead(String chatId, String readerId) async {
    try {
      // Busca mensagens não lidas que não são do leitor
      final unreadMessages = await _messagesCollection
          .where('chatId', isEqualTo: chatId)
          .where('senderId', isNotEqualTo: readerId)
          .where('isRead', isEqualTo: false)
          .get();

      // Atualiza cada mensagem
      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      // Reseta contador de não lidas no chat
      batch.update(_chatsCollection.doc(chatId), {'unreadCount': 0});

      await batch.commit();
    } catch (e) {
      // Ignora erros de marcação como lido
      print('Erro ao marcar mensagens como lidas: $e');
    }
  }

  /// Deleta um chat e suas mensagens
  Future<void> deleteChat(String chatId) async {
    try {
      // Deleta todas as mensagens do chat
      final messages = await _messagesCollection
          .where('chatId', isEqualTo: chatId)
          .get();

      final batch = _firestore.batch();
      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }

      // Deleta o chat
      batch.delete(_chatsCollection.doc(chatId));

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao deletar chat: $e');
    }
  }

  /// Busca um chat por ID
  Future<ChatModel?> getChatById(String chatId) async {
    try {
      final doc = await _chatsCollection.doc(chatId).get();
      if (doc.exists) {
        return ChatModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
