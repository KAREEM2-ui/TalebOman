import 'package:flutter/material.dart';
import 'package:projectapp/Models/UserProfile.dart';
import '../utils/Enums/Status.dart';
import '../Repositories/UserProfileRepo.dart';

class UserProfileProvider extends ChangeNotifier
{
  late UserProfileRepo _userProfileRepo;
  Userprofile? _userProfile;
  Userprofile? get userProfile => _userProfile;
  Status status = Status.initial;
  late String uid;
  bool didUpdated = false;


  Future<void> updateUserProfile(Userprofile userProfile) async {
    try
    {
      status = Status.loading;
      notifyListeners();
      await _userProfileRepo.updateUserProfile(uid, userProfile);
      status = Status.completed;
      _userProfile = userProfile;
      notifyListeners();
    }
    catch(e)
    {
      status = Status.initial;
      notifyListeners();
      throw Exception('Failed to update user profile: $e');
    }

  }


  Future<void> _loadProfile(String uid) async
  {
    status = Status.loading;
    notifyListeners();


    try
    {
      _userProfile = await _userProfileRepo.fetchUserProfile(uid);
      print(_userProfile?.fullName);
      status = Status.completed;
      notifyListeners();
    }
    catch(e)
    {
      status = Status.error;
      notifyListeners();
    }
  }


  UserProfileProvider(this.uid)
  {
    _userProfileRepo = UserProfileRepo();
    _loadProfile(uid);
  }







}