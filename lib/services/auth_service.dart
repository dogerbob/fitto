import 'package:fitto/models/user.dart';
import 'package:fitto/services/storage_service.dart';
import 'package:fitto/utils/api_placeholders.dart';

class AuthService {
  final StorageService _storage = StorageService();
  UserModel? _currentUser;

  Future<void> initialize() async {
    final userJson = await _storage.getJson(StorageService.userKey);
    if (userJson != null) {
      _currentUser = UserModel.fromJson(userJson);
    } else {
      await _createDefaultUser();
    }
  }

  Future<void> _createDefaultUser() async {
    final now = DateTime.now();
    _currentUser = UserModel(
      id: 'user_1',
      name: 'John Doe',
      email: 'john.doe@fitto.com',
      weight: 75.0,
      height: 175.0,
      age: 28,
      gender: 'male',
      dailyCalorieGoal: 2200,
      dailyWaterGoal: 8,
      dailyStepsGoal: 10000,
      isPremium: false,
      createdAt: now,
      updatedAt: now,
    );
    await _storage.saveJson(StorageService.userKey, _currentUser!.toJson());
  }

  UserModel? get currentUser => _currentUser;

  Future<bool> signInWithGoogle() async {
    final result = await ApiPlaceholders.socialSignIn('google');
    if (result['success'] == true) {
      await _createDefaultUser();
      return true;
    }
    return false;
  }

  Future<bool> signInWithApple() async {
    final result = await ApiPlaceholders.socialSignIn('apple');
    if (result['success'] == true) {
      await _createDefaultUser();
      return true;
    }
    return false;
  }

  Future<void> updateUser(UserModel user) async {
    _currentUser = user.copyWith(updatedAt: DateTime.now());
    await _storage.saveJson(StorageService.userKey, _currentUser!.toJson());
  }

  Future<void> signOut() async {
    _currentUser = null;
    await _storage.clear();
  }

  bool get isAuthenticated => _currentUser != null;
}
