import 'package:flutter/material.dart';
import 'package:projectapp/FirestoreCache/cache.dart';
import 'package:projectapp/Models/UserProfile.dart';
import '../utils/Enums/Status.dart';
import '../Models/Scholarship.dart';
import '../Repositories/ScholarshipRepo.dart';

class MatchesListProvider extends ChangeNotifier 
{
  late Userprofile _userProfile;
  late ScholarshipRepo _scholarshipRepo;
  List<Scholarship>? matches;
  Status status = Status.initial;

  String? errorMsg;


  double _calculatePercentage(Scholarship scholarship)
  {
    double baseScorepercentage = 50.0;

    // Additional scoring based on criteria
    baseScorepercentage += (_userProfile.cgpa - scholarship.minCGPA) / (4.0 - scholarship.minCGPA)* 25;

    baseScorepercentage += (_userProfile.ieltsScore - scholarship.minIelts) / (9.0 - scholarship.minIelts) * 15; 


    baseScorepercentage += 15; // Field of study match bonus

    
    if(baseScorepercentage > 100.0) {
      baseScorepercentage = 100.0;
    } 

    return baseScorepercentage;

  }

  Future<void> loadScholarships([bool ignoreCache = false]) async
  {
    status = Status.loading;
    notifyListeners();

    

    try
    {
       // Load from cache first, if allowed 
       if(!ignoreCache)
       {
          matches = await FirestoreCache.getScholarshipsMatchedList();
       }
       
        // if not in cache, load from firestore
        matches ??= await _scholarshipRepo.fetchScholarships(_userProfile);

         // Save to cache
          await FirestoreCache.updateScholarshipsMatchedList(matches!);



          if(matches!.isNotEmpty)
          {
              for (var scholarship in matches!) {
                scholarship.percentageScore = _calculatePercentage(scholarship);
              }

              matches!.sort((a,b)=> b.percentageScore!.compareTo(a.percentageScore!));
          }       


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





  MatchesListProvider(Userprofile userProfile,bool didProfileUpdate)
  {
    _userProfile = userProfile;
    _scholarshipRepo = ScholarshipRepo();
    
    // if profile was updated, ignore cache
    loadScholarships(didProfileUpdate);

  }

}