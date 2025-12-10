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
  int alertsCount = 0;


  Future<void> updateUserProfile(Userprofile userProfile) async {
    try
    {
      status = Status.loading;
      notifyListeners();
      await _userProfileRepo.updateUserProfile(uid, userProfile);
      status = Status.completed;
      _userProfile = userProfile;
      didUpdated = true;
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
      status = Status.completed;
      await alertsCountInitial();
      notifyListeners();
    }
    catch(e)
    {
      status = Status.error;
      notifyListeners();
    }
  }


  Future<void> alertsCountInitial() async
  {
    if(_userProfile == null) return;

    try
    {
      alertsCount = await _userProfileRepo.fetchAlertsCount(uid);
    }
    catch(e)
    {
      // handle error if needed
    }
  }

  Future<void> markAllAlertsAsRead() async
  {
    if(_userProfile == null || alertsCount == 0) return;

    try
    {
      await _userProfileRepo.markAllAsRead(uid);
      alertsCount = 0;
      notifyListeners();
    }
    catch(e)
    {
      throw Exception('Failed to mark alerts as read: $e');
    }
  }


  UserProfileProvider(this.uid)
  {
    _userProfileRepo = UserProfileRepo();
    _loadProfile(uid);
  }







}