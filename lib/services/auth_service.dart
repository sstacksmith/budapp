import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cache_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CacheService _cacheService = CacheService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Check if email is verified
      if (!result.user!.emailVerified) {
        await _auth.signOut(); // Wyloguj jeśli email nie zweryfikowany
        throw Exception('EMAIL_NOT_VERIFIED');
      }
      
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await result.user?.updateDisplayName(name);
      await result.user?.sendEmailVerification();
      
      // Create user document in Firestore
          await _firestore.collection('users').doc(result.user!.uid).set({
            'name': name,
            'email': email,
            'emailVerified': false,
            'role': 'user', // user, subscription, admin
            'subscriptionType': 'free',
            'subscriptionExpiry': null,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
          });

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    // Clear user cache
    if (currentUser != null) {
      await _cacheService.clearCache('user_subscription_${currentUser!.uid}');
    }
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String name) async {
    try {
      await currentUser?.updateDisplayName(name);
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'name': name,
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get user subscription info
  Future<Map<String, dynamic>?> getUserSubscription() async {
    try {
      
      if (currentUser == null) {
        return null;
      }
      
      // Check cache first
      final cacheKey = 'user_subscription_${currentUser!.uid}';
      final cachedData = _cacheService.getFromCache(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      
      
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        
        // Convert Timestamps to serializable format before caching
        if (data != null) {
          Map<String, dynamic> cacheableData = Map.from(data);
          
          // Convert Timestamp fields to ISO8601 strings
          if (data['createdAt'] is Timestamp) {
            cacheableData['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          if (data['lastLogin'] is Timestamp) {
            cacheableData['lastLogin'] = (data['lastLogin'] as Timestamp).toDate().toIso8601String();
          }
          if (data['lastUpdated'] is Timestamp) {
            cacheableData['lastUpdated'] = (data['lastUpdated'] as Timestamp).toDate().toIso8601String();
          }
          if (data['subscriptionExpiry'] is Timestamp) {
            cacheableData['subscriptionExpiry'] = (data['subscriptionExpiry'] as Timestamp).toDate().toIso8601String();
          }
          
          // Cache the serializable data for 1 hour
          _cacheService.saveToCache(cacheKey, cacheableData, duration: const Duration(hours: 1));
        }
        
        return data;
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get subscription info: $e');
    }
  }

  // Update subscription
  Future<void> updateSubscription(String subscriptionType, DateTime expiryDate) async {
    try {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'subscriptionType': subscriptionType,
        'subscriptionExpiry': expiryDate,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  // Check if user has active subscription (role-based)
  Future<bool> hasActiveSubscription() async {
    try {
      
      Map<String, dynamic>? userData = await getUserSubscription();
      
      if (userData == null) {
        return false;
      }

      
      String role = userData['role'] ?? 'user';
      
      // ADMIN - ma dostęp do wszystkiego
      if (role == 'admin') {
        return true;
      }
      
      // SUBSCRIPTION - sprawdź czy subskrypcja jest aktywna
      if (role == 'subscription') {
        
        // Handle both Timestamp and String (from cache)
        DateTime? expiryDate;
        var expiryValue = userData['subscriptionExpiry'];
        
        if (expiryValue == null) {
          return false;
        }
        
        if (expiryValue is Timestamp) {
          expiryDate = expiryValue.toDate();
        } else if (expiryValue is String) {
          expiryDate = DateTime.tryParse(expiryValue);
        }
        
        if (expiryDate == null) {
          return false;
        }
        
        bool isActive = DateTime.now().isBefore(expiryDate);
        return isActive;
      }
      
      // USER - brak dostępu do premium
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Get user role
  Future<String> getUserRole() async {
    try {
      Map<String, dynamic>? userData = await getUserSubscription();
      return userData?['role'] ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    
    switch (e.code) {
      case 'user-not-found':
        return 'Nie znaleziono użytkownika z tym adresem email.';
      case 'wrong-password':
        return 'Nieprawidłowe hasło.';
      case 'email-already-in-use':
        return 'Konto z tym adresem email już istnieje.';
      case 'weak-password':
        return 'Hasło jest za słabe (minimum 6 znaków).';
      case 'invalid-email':
        return 'Nieprawidłowy adres email.';
      case 'invalid-api-key':
        return 'Błąd konfiguracji Firebase (API key). Kod błędu: ${e.code}';
      case 'api-key-not-valid':
        return 'API key nie jest poprawnie skonfigurowany w Firebase Console. Włącz Identity Toolkit API w Google Cloud Console.';
      case 'user-disabled':
        return 'To konto zostało wyłączone.';
      case 'too-many-requests':
        return 'Zbyt wiele prób logowania. Spróbuj ponownie później.';
      case 'operation-not-allowed':
        return 'Email/Password authentication nie jest włączony w Firebase Console.';
      default:
        return 'Błąd Firebase [${e.code}]: ${e.message}';
    }
  }

  // Handle custom exceptions
  String handleCustomException(Exception e) {
    if (e.toString().contains('EMAIL_NOT_VERIFIED')) {
      return 'EMAIL_NOT_VERIFIED';
    }
    return e.toString();
  }
}

