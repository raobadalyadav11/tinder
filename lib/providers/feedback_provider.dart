import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FeedbackProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> submitFeedback(double rating, String feedback) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.submitFeedback({
        'rating': rating,
        'feedback': feedback,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _setLoading(false);
      return response['success'] ?? false;
    } catch (e) {
      _setError('Failed to submit feedback: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> reportUser(String userId, String reason, String details) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.reportUser({
        'userId': userId,
        'reason': reason,
        'details': details,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _setLoading(false);
      return response['success'] ?? false;
    } catch (e) {
      _setError('Failed to report user: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> blockUser(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.blockUser(userId);
      _setLoading(false);
      return response['success'] ?? false;
    } catch (e) {
      _setError('Failed to block user: $e');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}