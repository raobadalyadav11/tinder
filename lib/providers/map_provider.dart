import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/location_helper.dart';

class MapProvider with ChangeNotifier {
  List<UserModel> _nearbyUsers = [];
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;

  List<UserModel> get nearbyUsers => _nearbyUsers;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNearbyUsers({double radius = 5.0}) async {
    _setLoading(true);
    _clearError();

    try {
      _currentPosition = await LocationHelper.getCurrentLocation();
      
      if (_currentPosition != null) {
        final users = await ApiService.getNearbyUsers(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          radius,
        );
        _nearbyUsers = users;
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load nearby users: $e');
      _setLoading(false);
    }
  }

  Future<void> updateUserLocation() async {
    try {
      final position = await LocationHelper.getCurrentLocation();
      if (position != null) {
        _currentPosition = position;
        await ApiService.updateLocation(position.latitude, position.longitude);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update location: $e');
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