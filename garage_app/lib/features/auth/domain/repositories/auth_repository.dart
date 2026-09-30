import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String name, String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
}
