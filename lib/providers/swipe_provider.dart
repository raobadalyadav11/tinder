import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';

class SwipeProvider with ChangeNotifier {
  List<UserModel> _candidates = [];
  List<UserModel> _matches = [];
  bool _isLoading = false;
  String? _error;
  int _currentIndex = 0;

  List<UserModel> get candidates => _candidates;
  List<UserModel> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentIndex => _currentIndex;
  UserModel? get currentCandidate => 
      _currentIndex < _candidates.length ? _candidates[_currentIndex] : null;

  void initialize() {
    SocketService.onNewMatch(_handleNewMatch);
  }

  Future<void> loadCandidates() async {
    _setLoading(true);
    _clearError();

    try {
      _candidates = await ApiService.getCandidates();
      _currentIndex = 0;
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load candidates: $e');
      _setLoading(false);
    }
  }

  Future<void> loadMatches() async {
    try {
      _matches = await ApiService.getMatches();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load matches: $e');
    }
  }

  Future<bool> swipeUser(String action) async {
    if (currentCandidate == null) return false;

    try {
      final response = await ApiService.recordSwipe(currentCandidate!.id, action);
      
      _currentIndex++;
      notifyListeners();
      
      if (response['isMatch'] == true) {
        _matches.add(currentCandidate!);
        return true; // Indicates a match
      }
      
      return false;
    } catch (e) {
      _setError('Failed to record swipe: $e');
      return false;
    }
  }

  Future<bool> likeUser() async {
    return await swipeUser('like');
  }

  Future<bool> passUser() async {
    return await swipeUser('pass');
  }

  Future<bool> superLikeUser() async {
    return await swipeUser('super_like');
  }

  void _handleNewMatch(Map<String, dynamic> matchData) {
    final user = UserModel.fromJson(matchData['user']);
    _matches.add(user);
    notifyListeners();
  }

  void resetCandidates() {
    _candidates.clear();
    _currentIndex = 0;
    notifyListeners();
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