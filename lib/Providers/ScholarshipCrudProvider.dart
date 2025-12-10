import 'package:flutter/material.dart';
import 'package:projectapp/Models/Scholarship.dart';
import 'package:projectapp/Repositories/ScholarshipRepo.dart';
import '../utils/Enums/Status.dart';


class ScholarshipCrudProvider extends ChangeNotifier {
  
  ScholarshipRepo _scholarshipRepo = ScholarshipRepo();
  List<Scholarship>? scholarships;
  List<Scholarship>? filteredScholarships;
  Status status = Status.initial;

  Future<void> fetchAllScholarships() async
  {

    status = Status.loading;
    notifyListeners();

    try
    {
        scholarships = await _scholarshipRepo.getAllScholarships();
        filteredScholarships = scholarships!;
        status = Status.completed;
        notifyListeners();

    }

    catch(e)
    {
      status = Status.error;
      notifyListeners();
    }
    

  
  }

  ScholarshipCrudProvider()
  {
    fetchAllScholarships();
  }



  Future<void> updateScholarship(Scholarship scholarship) async
  {
    status = Status.loading;
    notifyListeners();

    try
    {
        await _scholarshipRepo.updateById(scholarship);
        final index = scholarships!.indexWhere((s) => s.id == scholarship.id);
        if (index != -1) {
          scholarships![index] = scholarship;
          filteredScholarships![index] = scholarship;
        }



        status = Status.completed;
        notifyListeners();

    }

    catch(e)
    {
      status = Status.error;
      notifyListeners();
    }
  }



  void applySearchFilter(String query) {
    if(!query.isEmpty)
    {
      filteredScholarships = scholarships!.where((scholarship) => 
        scholarship.Title.toLowerCase().contains(query.toLowerCase()) ||
        (scholarship.country.toLowerCase().contains(query.toLowerCase()))
      ).toList();
      notifyListeners();
    }
  }

  void clearSearchFilter() {
    filteredScholarships = scholarships ?? [];
  }

  void filter(double ielts,double cgpa, DateTime deadline)
  {
    filteredScholarships = scholarships!.where((scholarship) => 
      (scholarship.minIelts <= ielts) &&
      (scholarship.minCGPA <= cgpa) &&
      (scholarship.deadline.isAfter(deadline))
    ).toList();

    notifyListeners();
  }

  Future<void> addScholarship(Scholarship scholarship) async
  {
    status = Status.loading;
    notifyListeners();

    try
    {
        final newScholarship = await _scholarshipRepo.addNew(scholarship);
        scholarships!.add(newScholarship);

        status = Status.completed;
        notifyListeners();

    }

    catch(e)
    {
      status = Status.error;
      notifyListeners();
    }
  }
  
}

