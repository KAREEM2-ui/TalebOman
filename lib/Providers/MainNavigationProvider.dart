import 'package:flutter/material.dart';


class MainNavigationProvider extends ChangeNotifier {
  int currentPageIdx = 1;

  
 
  void updateIndex(int page) {
    currentPageIdx = page;
    notifyListeners();
  }


}