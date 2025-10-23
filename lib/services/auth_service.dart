import 'package:fitto/models/user.dart';
import 'package:fitto/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final StorageService _storage = StorageService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel? _currentUser;

  Future<void> initialize() async {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserFromFirebase(user);
      } else {
        _currentUser = null;
      }
    });

    // Check if user is already signed in
    final user = _auth.currentUser;
    if (user != null) {
      await _loadUserFromFirebase(user);
    } else {
      // Load from local storage as fallback
      final userJson = await _storage.getJson(StorageService.userKey);
      if (userJson != null) {
        _currentUser = UserModel.fromJson(userJson);
      }
    }
  }

  Future<void> _loadUserFromFirebase(User firebaseUser) async {
    try {
      // Try to load user data from local storage first
      final userJson = await _storage.getJson(StorageService.userKey);
      if (userJson != null) {
        _currentUser = UserModel.fromJson(userJson);
        return;
      }

      // Create new user from Firebase data
      final now = DateTime.now();
      _currentUser = UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'User',
        email: firebaseUser.email ?? '',
        weight: 75.0, // Default values
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
    } catch (e) {
      print('Error loading user from Firebase: $e');
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
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _loadUserFromFirebase(userCredential.user!);
        return true;
      }
      return false;
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      // For Apple Sign In, you would typically use the apple_sign_in package
      // For now, we'll create a mock implementation
      // In a real app, you would implement Apple Sign In here
      
      // Create a mock user for demonstration
      final now = DateTime.now();
      _currentUser = UserModel(
        id: 'apple_user_${now.millisecondsSinceEpoch}',
        name: 'Apple User',
        email: 'user@privaterelay.appleid.com',
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
      return true;
    } catch (e) {
      print('Error signing in with Apple: $e');
      return false;
    }
  }

  Future<void> updateUser(UserModel user) async {
    _currentUser = user.copyWith(updatedAt: DateTime.now());
    await _storage.saveJson(StorageService.userKey, _currentUser!.toJson());
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _currentUser = null;
      await _storage.clear();
    } catch (e) {
      print('Error signing out: $e');
      // Still clear local data even if Firebase signout fails
      _currentUser = null;
      await _storage.clear();
    }
  }

  bool get isAuthenticated => _currentUser != null;
}
