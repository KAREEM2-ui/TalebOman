import 'package:flutter/material.dart';
import 'package:projectapp/Models/UserProfile.dart';
import '../utils/Enums/Status.dart';
import '../Models/Scholarship.dart';
import '../Repositories/ScholarshipRepo.dart';

class MatchesListProvider extends ChangeNotifier 
{
  late Userprofile _userProfile;
  late ScholarshipRepo _scholarshipRepo;
  List<Scholarship> matches = [];
  Status status = Status.initial;

  String? errorMsg;

  void _initState() async
  {
    status = Status.loading;
    notifyListeners();


    try
    {
        matches = await _scholarshipRepo.fetchScholarships(_userProfile);
        status = Status.completed;
        notifyListeners();


        
    }
    catch(e)
    {
      status = Status.error;
      print(e.toString());
      errorMsg = "Failed to load matches.";
      notifyListeners();
    }

  }



  MatchesListProvider(Userprofile userProfile)
  {
    _userProfile = userProfile;
    _scholarshipRepo = ScholarshipRepo();
    
    _initState();

  }

}