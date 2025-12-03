import 'package:flutter/material.dart';


class MainNavigationProvider extends ChangeNotifier {
  int currentPageIdx = 1;

  
 
  void updateIndex(int page) {
    currentPageIdx = page;
    notifyListeners();
  }


}




// making navigation enums for better readability
enum EnPages { profile, matches, alerts }
