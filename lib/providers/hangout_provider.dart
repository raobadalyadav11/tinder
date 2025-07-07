import 'package:flutter/material.dart';
import '../models/hangout_model.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';

class HangoutProvider with ChangeNotifier {
  List<HangoutModel> _hangouts = [];
  List<HangoutModel> _myHangouts = [];
  bool _isLoading = false;
  String? _error;

  List<HangoutModel> get hangouts => _hangouts;
  List<HangoutModel> get myHangouts => _myHangouts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void initialize() {
    SocketService.onHangoutUpdate(_handleHangoutUpdate);
  }

  Future<void> loadNearbyHangouts(double lat, double lng, {double radius = 5.0}) async {
    _setLoading(true);
    _clearError();

    try {
      _hangouts = await ApiService.getNearbyHangouts(lat, lng, radius);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load hangouts: $e');
      _setLoading(false);
    }
  }

  Future<bool> createHangout(Map<String, dynamic> hangoutData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.createHangout(hangoutData);
      
      if (response['success']) {
        final hangout = HangoutModel.fromJson(response['hangout']);
        _hangouts.insert(0, hangout);
        _myHangouts.add(hangout);
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Failed to create hangout');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Failed to create hangout: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> rsvpHangout(String hangoutId) async {
    try {
      final response = await ApiService.rsvpHangout(hangoutId);
      
      if (response['success']) {
        // Update local hangout data
        final hangoutIndex = _hangouts.indexWhere((h) => h.id == hangoutId);
        if (hangoutIndex != -1) {
          final updatedHangout = HangoutModel.fromJson(response['hangout']);
          _hangouts[hangoutIndex] = updatedHangout;
          notifyListeners();
        }
        
        SocketService.joinHangoutRoom(hangoutId);
        return true;
      } else {
        _setError(response['message'] ?? 'Failed to RSVP');
        return false;
      }
    } catch (e) {
      _setError('Failed to RSVP: $e');
      return false;
    }
  }

  void _handleHangoutUpdate(Map<String, dynamic> updateData) {
    final hangoutId = updateData['hangoutId'];
    final hangoutIndex = _hangouts.indexWhere((h) => h.id == hangoutId);
    
    if (hangoutIndex != -1) {
      _hangouts[hangoutIndex] = HangoutModel.fromJson(updateData['hangout']);
      notifyListeners();
    }
  }

  List<HangoutModel> getFilteredHangouts(String category) {
    if (category == 'All') return _hangouts;
    return _hangouts.where((h) => h.category == category).toList();
  }

  void joinHangoutChat(String hangoutId) {
    SocketService.joinHangoutRoom(hangoutId);
  }

  void sendHangoutMessage(String hangoutId, String message) {
    SocketService.sendHangoutMessage(hangoutId, message);
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