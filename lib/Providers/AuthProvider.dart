import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectapp/Models/UserDetails.dart';
import 'package:projectapp/Repositories/AuthRepo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/Enums/Status.dart';


class AuthenticationProvider extends ChangeNotifier
{
  final AuthRepo _authRepo = AuthRepo();
  UserDetails? _userDetails;
  Status loginStatus = Status.initial;
  Status registrationStatus = Status.initial;
  String? errorMessage;

  bool get isLoggedIn => _userDetails != null;

  UserDetails? get userDetails => _userDetails;

  AuthenticationProvider()
  {
    _authRepo.authStateChanges.listen((User? user) async{
      


      if (user != null) {
    
        // loading user details from firestore
        _userDetails = await _authRepo.getUserDetails(user.uid);
        await Future.delayed(const Duration(seconds: 2));

         if(_userDetails == null)
         {
            loginStatus = Status.error;
         }
         else
         {
            loginStatus = Status.completed;
         }
        
      } else {
        // User is signed out , notify listeners
        _userDetails = null;
        loginStatus = Status.initial;
      }
      notifyListeners();
    });
}

  Future<void> RegisterWithEmailAndPassword(String email, String password) async
  {
    try{
      registrationStatus = Status.loading;
      notifyListeners();

      // registering user
      await _authRepo.createUser(email, password);

      

      // notify listeners completed
      registrationStatus = Status.completed;
      notifyListeners();
    }
    catch(e )
    {
      registrationStatus = Status.error;
      errorMessage = e.toString();
      notifyListeners();

      // to stop further execution
      rethrow ;
    }
  }


  Future<void> LoginWithEmailAndPassword(String email, String password) async
  {
    try{
      loginStatus = Status.loading;
      notifyListeners();

      // logging in user
      await _authRepo.signInWithEmailAndPassword(email, password);

      if(!_authRepo.currentUser!.emailVerified)
      {
        throw Exception("Email not verified. Please verify your email before logging in.");
      }

      // generate the token for push notification
      String? token = await FirebaseMessaging.instance.getToken();
      if(token == null)
      {
        throw Exception("Unable to get token");
      }

      // update the token in firestore
      await _authRepo.updateUserToken(_authRepo.currentUser!.uid, token);

      // get user details
      _userDetails = await _authRepo.getUserDetails(_authRepo.currentUser!.uid);

      

      // notify listeners completed
      loginStatus = Status.completed;
      notifyListeners();

    }
    catch(e)
    {
      loginStatus = Status.error;
      errorMessage = e.toString();
      notifyListeners();

      // to stop further execution
      rethrow; 
    }
  }


  Future<void> logout() async
  {
    await _authRepo.signOut();
    _userDetails = null;
    loginStatus = Status.initial;
    notifyListeners();
  }
}