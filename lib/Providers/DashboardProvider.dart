import 'package:flutter/material.dart';
import 'package:projectapp/Models/Scholarship.dart';
import 'package:projectapp/Models/popularScholarships.dart';
import 'package:projectapp/Models/scholarshipViewEvent.dart';
import 'package:projectapp/Repositories/ScholarshipRepo.dart';
import 'package:projectapp/Repositories/UserProfileRepo.dart';
import 'package:projectapp/utils/Enums/Status.dart';
import 'package:projectapp/Repositories/analyticsRepo.dart';


class DashboardProvider extends ChangeNotifier{

  final AnalyticsRepo _dashboardRepo = AnalyticsRepo();
  final ScholarshipRepo _scholarshipRepo = ScholarshipRepo();
  final UserProfileRepo _userProfileRepo = UserProfileRepo();

  EnPopularScholarshipFilter popularScholarshipFilter = EnPopularScholarshipFilter.thisWeek;
  Status popularScholarshipsStatus = Status.initial;
  Status summaryStatus = Status.initial;
  String? errorMsg;
  List<Popularscholarships> popularScholarships = [];
  int? totalScholarships = 0;
  int? totalUsers = 0;
  int? activeScholarships = 0;
  double get averageCgpa => popularScholarships.isEmpty ? 0 : (popularScholarships.map((s)=> s.scholarship.minCGPA)).reduce((a,b) => a + b) / popularScholarships.length;
  double get averageIelts => popularScholarships.isEmpty ? 0 : (popularScholarships.map((s)=> s.scholarship.minIelts)).reduce((a,b) => a + b) / popularScholarships.length;
  List<String> get commanFieldofInterest {
    Set<String> fields = {};

    for(var popularScholarship in popularScholarships)
    {
      fields.addAll(popularScholarship.scholarship.fieldsOfStudy);
    }

    return fields.toList();
  }



  DashboardProvider()
  {
    _init();
  }








  DateTime _getDateTimeFromFilter(EnPopularScholarshipFilter filter)
  {
    DateTime now = DateTime.now();

    switch(filter)
    {
      case EnPopularScholarshipFilter.oneHour:
        return now.subtract(Duration(hours: 1));
      case EnPopularScholarshipFilter.today:
        return now.subtract(Duration(days: 1));
      case EnPopularScholarshipFilter.thisWeek:
        return now.subtract(Duration(days: 7));
      case EnPopularScholarshipFilter.thisMonth:
        return now.subtract(Duration(days: 30));
      case EnPopularScholarshipFilter.thisYear:
        return now.subtract(Duration(days: 365));
      case EnPopularScholarshipFilter.allTime:
        return DateTime(2000); // arbitrary old date
    }
  }



  Future<void> fetchPopularScholarships(EnPopularScholarshipFilter filter) async 
  { 
    popularScholarshipFilter = filter;

    // reset list
    popularScholarships = [];

    popularScholarshipsStatus = Status.loading;
    notifyListeners();

    try
    {
      List<ScholarshipViewEvent> analyticsData = await _dashboardRepo.getLatestsScholarshipsViewed(_getDateTimeFromFilter(filter));
      Map<String, int> scholarshipViewCount = {};

      for(var event in analyticsData)
      {
        scholarshipViewCount[event.scholarshipId] = (scholarshipViewCount[event.scholarshipId] ?? 0) + 1;
      }

      List<MapEntry<String, int>> sortedScholarshipViews = scholarshipViewCount.entries.toList();
      sortedScholarshipViews.sort((a,b) => b.value.compareTo(a.value));


      // Fetch scholarship details for top viewed scholarships (assuming top 5)
      for(int i = 0; i < 5 && i < sortedScholarshipViews.length; i++)
      {
        String scholarshipId = sortedScholarshipViews[i].key;
        Scholarship? scholarship = await _scholarshipRepo.getScholarshipById(scholarshipId);
        if(scholarship != null)
        {
          popularScholarships.add(Popularscholarships(
            scholarship: scholarship,
            count: sortedScholarshipViews[i].value,
          ));
        }
      }

      popularScholarshipsStatus = Status.completed;
      notifyListeners();
    }
    catch(e)
    {
      popularScholarshipsStatus = Status.error;
      errorMsg = e.toString();
      notifyListeners();
    }
  }
  Future<void> fetchSummaryDetails() async 
  { 
    summaryStatus = Status.loading;
    notifyListeners();

    try
    {
      
      // get total scholarships
      totalScholarships = await _scholarshipRepo.getTotalScholarshipsCount();

      // get active scholarships
      activeScholarships = await _scholarshipRepo.getActiveScholarshipsCount();

      // get total users
      totalUsers = await _userProfileRepo.getTotalUserProfilesCount();


      summaryStatus = Status.completed;
      notifyListeners();
    }
    catch(e)
    {
      summaryStatus = Status.error;
      errorMsg = e.toString();
      notifyListeners();
    }
  }

  Future<void> _init() async
  {
  


    fetchPopularScholarships(popularScholarshipFilter);
    fetchSummaryDetails();
  }


}


enum EnPopularScholarshipFilter { oneHour,today,thisWeek,thisMonth,thisYear, allTime}


