import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo para uma conversa/chat
class ChatModel {
  final String id;
  final String clientId;
  final String driverId;
  final String driverName;
  final String? driverPhoto;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool isPinned;
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.clientId,
    required this.driverId,
    required this.driverName,
    this.driverPhoto,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.isPinned = false,
    required this.createdAt,
  });

  factory ChatModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ChatModel(
      id: id,
      clientId: data['clientId'] ?? '',
      driverId: data['driverId'] ?? '',
      driverName: data['driverName'] ?? 'Motorista',
      driverPhoto: data['driverPhoto'],
      lastMessage: data['lastMessage'],
      lastMessageTime: data['lastMessageTime']?.toDate(),
      unreadCount: data['unreadCount'] ?? 0,
      isPinned: data['isPinned'] ?? false,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhoto': driverPhoto,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : null,
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// Modelo para uma mensagem
class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderType; // 'client' ou 'driver'
  final String message;
  final String type; // 'text', 'audio', 'image'
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderType,
    required this.message,
    this.type = 'text',
    required this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromFirestore(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderType: data['senderType'] ?? 'client',
      message: data['message'] ?? '',
      type: data['type'] ?? 'text',
      timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'senderType': senderType,
      'message': message,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
