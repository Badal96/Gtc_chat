import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAeuth = FirebaseAuth.instance;

  User? get currrentUser => _firebaseAeuth.currentUser;

  Stream<User?> get authStateChnages => _firebaseAeuth.authStateChanges();

  Future<void> signin({
    required String email, 
    required String password}) async {

    await _firebaseAeuth.signInWithEmailAndPassword(
        email: email,
        password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    
    await _firebaseAeuth.createUserWithEmailAndPassword(
        email: email, 
        password: password);
  }

  Future<void> signOut() async {
    await _firebaseAeuth.signOut();
  }
}
