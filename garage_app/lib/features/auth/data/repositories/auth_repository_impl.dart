import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkingzero/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Salva ou mescla o documento do usuário
    await _firestore.collection('users').doc(cred.user!.uid).set({
      'email': cred.user!.email,
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return cred;
  }

  @override
  Future<UserCredential> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Atualiza nome de exibição no Firebase Auth
    await cred.user!.updateDisplayName(name);

    // Cria o documento do usuário no Firestore
    await _firestore.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': cred.user!.email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return cred;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {

    await _googleSignIn.initialize();
    final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Login cancelado pelo usuário',
      );
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    UserCredential userCred = await _auth.signInWithCredential(credential);

    // Salva os dados do perfil do Google no Firestore
    await _firestore.collection('users').doc(userCred.user!.uid).set({
      'email': userCred.user!.email,
      'displayName': userCred.user!.displayName,
      'photoURL': userCred.user!.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return userCred;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
