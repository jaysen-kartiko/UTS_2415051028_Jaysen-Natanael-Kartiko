import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/supabase_service.dart';

class UserProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  UserProfile? _userProfile;
  bool _isLoading = false;
  String _errorMessage = '';

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchUserProfile(int userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _userProfile = await _supabaseService.fetchUserProfile(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}