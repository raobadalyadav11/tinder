import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../models/hangout_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Auth endpoints
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: _headers,
      body: jsonEncode(userData),
    );
    return _handleResponse(response);
  }

  // User endpoints
  static Future<UserModel> getProfile(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$userId'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return UserModel.fromJson(data['user']);
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/update'),
      headers: _headers,
      body: jsonEncode(profileData),
    );
    return _handleResponse(response);
  }

  // Swipe endpoints
  static Future<List<UserModel>> getCandidates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/swipe/candidates'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return (data['candidates'] as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  static Future<Map<String, dynamic>> recordSwipe(String targetUserId, String action) async {
    final response = await http.post(
      Uri.parse('$baseUrl/swipe'),
      headers: _headers,
      body: jsonEncode({'targetUserId': targetUserId, 'action': action}),
    );
    return _handleResponse(response);
  }

  static Future<List<UserModel>> getMatches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/swipe/matches'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return (data['matches'] as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  // Chat endpoints
  static Future<List<MessageModel>> getChatHistory(String userId, int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chat/history/$userId?page=$page'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return (data['messages'] as List)
        .map((json) => MessageModel.fromJson(json))
        .toList();
  }

  static Future<Map<String, dynamic>> sendMessage(String receiverId, String content, MessageType type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/send'),
      headers: _headers,
      body: jsonEncode({
        'receiverId': receiverId,
        'content': content,
        'type': type.toString().split('.').last,
      }),
    );
    return _handleResponse(response);
  }

  // Hangout endpoints
  static Future<List<HangoutModel>> getNearbyHangouts(double lat, double lng, double radius) async {
    final response = await http.get(
      Uri.parse('$baseUrl/hangout/nearby?lat=$lat&lng=$lng&radius=$radius'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return (data['hangouts'] as List)
        .map((json) => HangoutModel.fromJson(json))
        .toList();
  }

  static Future<Map<String, dynamic>> createHangout(Map<String, dynamic> hangoutData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/hangout/create'),
      headers: _headers,
      body: jsonEncode(hangoutData),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> rsvpHangout(String hangoutId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/hangout/rsvp'),
      headers: _headers,
      body: jsonEncode({'hangoutId': hangoutId}),
    );
    return _handleResponse(response);
  }

  // Activity endpoints
  static Future<List<Map<String, dynamic>>> getActivitySuggestions(double lat, double lng) async {
    final response = await http.get(
      Uri.parse('$baseUrl/activity/suggestions?lat=$lat&lng=$lng'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return List<Map<String, dynamic>>.from(data['activities']);
  }

  static Future<Map<String, dynamic>> proposeActivity(String activityId, List<String> userIds, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/activity/propose'),
      headers: _headers,
      body: jsonEncode({
        'activityId': activityId,
        'userIds': userIds,
        'message': message,
      }),
    );
    return _handleResponse(response);
  }

  // Location endpoints
  static Future<Map<String, dynamic>> updateLocation(double lat, double lng) async {
    final response = await http.post(
      Uri.parse('$baseUrl/location/update'),
      headers: _headers,
      body: jsonEncode({'latitude': lat, 'longitude': lng}),
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}