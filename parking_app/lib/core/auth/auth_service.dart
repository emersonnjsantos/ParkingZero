import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Register new user with email and password
  Future<UserCredential> registerWithEmail(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Get ID token for gRPC metadata
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  /// Create gRPC CallOptions with Firebase auth token
  Future<CallOptions> getAuthCallOptions() async {
    final token = await getIdToken();
    return CallOptions(
      metadata: {if (token != null) 'authorization': 'Bearer $token'},
    );
  }
}
