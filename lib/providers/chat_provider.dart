import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';

class ChatProvider with ChangeNotifier {
  final Map<String, List<MessageModel>> _conversations = {};
  final Map<String, bool> _typingUsers = {};
  bool _isLoading = false;

  Map<String, List<MessageModel>> get conversations => _conversations;
  Map<String, bool> get typingUsers => _typingUsers;
  bool get isLoading => _isLoading;

  void initialize() {
    SocketService.onMessageReceived(_handleNewMessage);
    SocketService.onTyping(_handleTyping);
  }

  Future<void> loadChatHistory(String userId, {int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final messages = await ApiService.getChatHistory(userId, page);
      
      if (page == 1) {
        _conversations[userId] = messages;
      } else {
        _conversations[userId] = [...messages, ...(_conversations[userId] ?? [])];
      }
      
      SocketService.joinChatRoom(_getChatId(userId));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load chat history: $e');
    }
  }

  Future<void> sendMessage(String receiverId, String content, MessageType type) async {
    try {
      final response = await ApiService.sendMessage(receiverId, content, type);
      
      if (response['success']) {
        final message = MessageModel.fromJson(response['message']);
        _addMessageToConversation(receiverId, message);
        SocketService.sendMessage(message);
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  void _handleNewMessage(MessageModel message) {
    final otherUserId = message.senderId;
    _addMessageToConversation(otherUserId, message);
  }

  void _addMessageToConversation(String userId, MessageModel message) {
    if (_conversations[userId] == null) {
      _conversations[userId] = [];
    }
    _conversations[userId]!.add(message);
    notifyListeners();
  }

  void _handleTyping(String userId, bool isTyping) {
    _typingUsers[userId] = isTyping;
    notifyListeners();
    
    if (isTyping) {
      Future.delayed(const Duration(seconds: 3), () {
        _typingUsers[userId] = false;
        notifyListeners();
      });
    }
  }

  void startTyping(String chatId) {
    SocketService.emitTyping(chatId, true);
  }

  void stopTyping(String chatId) {
    SocketService.emitTyping(chatId, false);
  }

  void markMessageAsRead(String messageId) {
    SocketService.markMessageAsRead(messageId);
  }

  String _getChatId(String userId) {
    // Generate consistent chat ID for two users
    return userId; // Simplified for demo
  }

  List<MessageModel> getConversation(String userId) {
    return _conversations[userId] ?? [];
  }

  void clearConversations() {
    _conversations.clear();
    _typingUsers.clear();
    notifyListeners();
  }
}