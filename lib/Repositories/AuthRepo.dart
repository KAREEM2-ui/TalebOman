import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectapp/Models/UserDetails.dart';


class AuthRepo
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool get isAthenticated => _firebaseAuth.currentUser != null;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }


  Future<void> createUser(String email, String password) async {
    
    // Credentials created
    User user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

    // User details
    await _firestore.collection('UsersDetails').doc(user.uid).set({
      'role': 'user',
      'token': null,
    });


    // Send email verification
    await user.sendEmailVerification();

  }

  Future<void> updateUserToken(String userId, String token) async {
    await _firestore.collection('UsersDetails').doc(userId).update({
      'token': token,
    });
  }


  Future<UserDetails?> getUserDetails(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('UsersDetails').doc(userId).get();
    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      return UserDetails.fromMap(data,userId);
    } else {
      return null;
    }
  }



  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
  Future<bool> verifyPasswordResetCode(String code) async {
    try {
      await _firebaseAuth.verifyPasswordResetCode(code);
      return true;
    } catch (e) {
      return false;
    }
  }
}