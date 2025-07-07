import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message_model.dart';

class SocketService {
  static IO.Socket? _socket;
  static String? _userId;

  static void connect(String userId, String token) {
    _userId = userId;
    _socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token, 'userId': userId},
    });

    _socket!.connect();
    _socket!.onConnect((_) => print('Connected to socket server'));
    _socket!.onDisconnect((_) => print('Disconnected from socket server'));
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _userId = null;
  }

  // Chat events
  static void joinChatRoom(String chatId) {
    _socket?.emit('join-chat', {'chatId': chatId});
  }

  static void sendMessage(MessageModel message) {
    _socket?.emit('send-message', message.toJson());
  }

  static void onMessageReceived(Function(MessageModel) callback) {
    _socket?.on('message-received', (data) {
      callback(MessageModel.fromJson(data));
    });
  }

  static void onTyping(Function(String userId, bool isTyping) callback) {
    _socket?.on('typing', (data) {
      callback(data['userId'], data['isTyping']);
    });
  }

  static void emitTyping(String chatId, bool isTyping) {
    _socket?.emit('typing', {
      'chatId': chatId,
      'userId': _userId,
      'isTyping': isTyping,
    });
  }

  static void markMessageAsRead(String messageId) {
    _socket?.emit('message-read', {'messageId': messageId});
  }

  // Proximity events
  static void onProximityAlert(Function(Map<String, dynamic>) callback) {
    _socket?.on('proximity-alert', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  static void updateLocation(double lat, double lng) {
    _socket?.emit('location-update', {
      'userId': _userId,
      'latitude': lat,
      'longitude': lng,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Match events
  static void onNewMatch(Function(Map<String, dynamic>) callback) {
    _socket?.on('new-match', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  // Hangout events
  static void joinHangoutRoom(String hangoutId) {
    _socket?.emit('join-hangout', {'hangoutId': hangoutId});
  }

  static void onHangoutUpdate(Function(Map<String, dynamic>) callback) {
    _socket?.on('hangout-update', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  static void sendHangoutMessage(String hangoutId, String message) {
    _socket?.emit('hangout-message', {
      'hangoutId': hangoutId,
      'message': message,
      'userId': _userId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void onHangoutMessage(Function(Map<String, dynamic>) callback) {
    _socket?.on('hangout-message', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  // Activity events
  static void onActivityInvite(Function(Map<String, dynamic>) callback) {
    _socket?.on('activity-invite', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  static bool get isConnected => _socket?.connected ?? false;
}