import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectapp/Repositories/ScholarshipRepo.dart';
import 'package:projectapp/utils/Enums/Status.dart';
import 'package:projectapp/Models/Scholarship.dart';
import 'package:excel/excel.dart';



class UploadingScholarshipFlowProvider extends ChangeNotifier {
  ScholarshipRepo _scholarshipRepo = ScholarshipRepo();
  Status _uploadStatus = Status.initial;
  List<Scholarship> _uploadeScholarships = [];
  String _errorMessage = '';
  
  get uploadStatus => _uploadStatus;
  get uploadedScholarships => _uploadeScholarships;
  get errorMessage => _errorMessage;

  






  // state and actions for the flow steps
  int _currentStep = 0;
  void goToNextStep() {
    if (_currentStep <  2) {
      _currentStep++;
      notifyListeners();
    } 
  }

  void cancel()
  {
    if (_currentStep > 0) {
      _currentStep = 0;
      notifyListeners();
    }
  }

  void reset()
  {
    _currentStep = 0;
    _uploadStatus = Status.initial;
    _uploadeScholarships = [];
    _errorMessage = '';
    notifyListeners();
  }

  int get currentStep => _currentStep;










  Future<void> upload(File file) async {
    _uploadStatus = Status.loading;
    notifyListeners();



      try
      {
    
      // Validate Excel file
      bool isValid = await  _isValidExcel(file); 
      if(!isValid)
      {
        _uploadStatus = Status.error;
        notifyListeners();
        return;
      }


      // Fill scholarships from excel
      await _fillScholarships(file);

     

      _uploadStatus = Status.completed;
      goToNextStep();

      }catch(e)
      {
        _uploadStatus = Status.error;
        _errorMessage = "An error occurred while processing the Excel file.";
        notifyListeners();
        return;
      }



      
  }
  
  Future<void> saveAll() async
  {
    _uploadStatus = Status.loading;
    notifyListeners();

    try
    {
       // Save scholarships to repository
      await _scholarshipRepo.addNewList(_uploadeScholarships);

      _uploadStatus = Status.completed;
      goToNextStep();
    }
    catch(e)
    {
      _uploadStatus = Status.error;
      _errorMessage = "An error occurred while saving scholarships to the database.";
      notifyListeners();
      return;
    }
  }



  Future<void> _fillScholarships(File file) async
  {
    List<int> bytes  = await file.readAsBytes();

    Excel ex = Excel.decodeBytes(bytes);

    Sheet? dataSheet = ex.tables["data"];



    // avoid the first row (header)  
    for(int i = 1; i < dataSheet!.maxRows; i++)
    {
      if(dataSheet.row(i).isEmpty)
      {
        continue;
      }

      // coverage list substring
      _uploadeScholarships.add(Scholarship.fromExcel(dataSheet.row(i)));
    }



  }
  void update(int idx,Scholarship scholarship)
  {
    _uploadeScholarships[idx] = scholarship;
    notifyListeners();
  }
  void addNew(Scholarship scholarship)
  {
    _uploadeScholarships.add(scholarship);
    notifyListeners();
  }
  void removeAt(int idx)
  {
    _uploadeScholarships.removeAt(idx);
    notifyListeners();
  }

  Future<bool> _isValidExcel(File file) async
  {
    /**
     Example row:
    'Global Excellence Scholarship,University of Oxford,UK,Fully Funded,[Tuition, Living Allowance],3.7,7.0,2025-01-15",[Medicine, Law],
     */
    
    List<int> bytes  = await file.readAsBytes();

    Excel ex = Excel.decodeBytes(bytes);

    // if empty excel file or data table not provided
    Sheet? dataSheet = ex.tables["data"];

    if(dataSheet == null)
    {
      _errorMessage = "Excel file does not have data sheet";
      return false;
    }

    // validate row existing
    if(dataSheet.maxRows <= 1)
    {
      _errorMessage = "Data sheet does not have any data rows";
      return false;
    }


    // validate each row, avoid the first row (header)
      for(int i = 1; i < dataSheet.maxRows; i++)
      {
        var row = dataSheet.row(i);


        // if one row empty skip
        if(row.isEmpty)
        {
          continue;
        }




        // validate Name
        if(!_isValidString(row[0]))
        {
          _errorMessage = "Scholarship Name is missing in the $i row of the data sheet";
          return false; 
        }
        


        // validate University
        if(!_isValidString(row[1]))
        {
          _errorMessage = "University  is missing in the $i row of the data sheet";
          return false; 
        }


        // validate country
        if(!_isValidString(row[2]))
        {
          _errorMessage = "Country  is missing in the $i row of the data sheet";
          return false; 
        }


        // validate type
        if(!_isValidString(row[3]))
        {
          _errorMessage = "Type  is missing in the $i row of the data sheet";
          return false; 
        }

        // validate Coverage
        if(row[4] != null && !_isValidList(row[4]!))
        {
          _errorMessage = "Coverage  is missing or formatted wrongly in the $i row of the data sheet";
          return false; 
        }

        // validate GPA
        if(!_isValidDouble(row[5]))
        {
          _errorMessage = "GPA  is missing or formatted wrongly in the $i row of the data sheet";
          return false; 
        }

        // validate IELTS
        if(!_isValidDouble(row[6]))
        {
          _errorMessage = "IELTS  is missing or formatted wrongly in the $i row of the data sheet";
          return false; 
        }



        // validate deadline
        if(!_isValidDate(row[7]))
        {
          _errorMessage = "Deadline  is missing or formatted wrongly in the $i row of the data sheet";
          return false; 
        }

        // validate Fields of Study *mandatory at least 1
        if(row[8] == null || !_isValidList(row[8]!))
        {
          _errorMessage = "Fields of Study  is missing or formatted wrongly in the $i row of the data sheet, at least one Field of Study is required";
          return false; 
        } 



      }


      return true;

  }

    // helper to validate list format
    bool _isValidList(Data listString)
      {
        // should start with [ and end with ]
        if(!listString.value.toString().startsWith('[') || !listString.value.toString().endsWith(']'))
        {
          return false;
        }

        // split by comma
        String content = listString.value.toString().substring(1, listString.value.toString().length - 1);
        List<String> items = content.split(',');

        // each item should not be empty
        for(String item in items)
        {
          if(item.trim().isEmpty)
          {
            return false;
          }
        }

        return true;
      }

    bool _isValidString(Data? value)
    {
      return value != null && value.value.toString().trim().isNotEmpty;
    }

    

    bool _isValidDouble(Data? value)
    {
      if(value == null || value.value.toString().trim().isEmpty)
      {
        return false;
      }

      return double.tryParse(value.value.toString()) != null;
    }

    bool _isValidDate(Data? value)
    {
      if(value == null || value.value.toString().trim().isEmpty)
      {
        return false;
      }

      return DateTime.tryParse(value.value.toString()) != null;
    }








    UploadingScholarshipFlowProvider();

}