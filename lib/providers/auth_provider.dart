import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';
import '../utils/storage_helper.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.login(email, password);
      
      if (response['success']) {
        final token = response['token'];
        final userData = response['user'];
        
        _currentUser = UserModel.fromJson(userData);
        ApiService.setToken(token);
        SocketService.connect(_currentUser!.id, token);
        
        await StorageHelper.saveToken(token);
        await StorageHelper.saveUser(_currentUser!);
        
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signup(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.signup(userData);
      
      if (response['success']) {
        final token = response['token'];
        final user = response['user'];
        
        _currentUser = UserModel.fromJson(user);
        ApiService.setToken(token);
        SocketService.connect(_currentUser!.id, token);
        
        await StorageHelper.saveToken(token);
        await StorageHelper.saveUser(_currentUser!);
        
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Signup failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    SocketService.disconnect();
    await StorageHelper.clearAll();
    notifyListeners();
  }

  Future<void> loadSavedUser() async {
    final token = await StorageHelper.getToken();
    final user = await StorageHelper.getUser();
    
    if (token != null && user != null) {
      _currentUser = user;
      ApiService.setToken(token);
      SocketService.connect(user.id, token);
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.updateProfile(profileData);
      
      if (response['success']) {
        _currentUser = UserModel.fromJson(response['user']);
        await StorageHelper.saveUser(_currentUser!);
        _setLoading(false);
      } else {
        _setError(response['message'] ?? 'Update failed');
        _setLoading(false);
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      _setLoading(false);
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