import 'package:flutter/material.dart';

class RefreshProvider extends ChangeNotifier {

  final List<Future<void> Function()> _listeners = [];
  void addEventListener(Future<void> Function() listener) {
    _listeners.add(listener);
  }

  void removeEventListener(Future<void> Function() listener) {
    _listeners.remove(listener);
  }


  void refresh() {

    for (var listener in _listeners) {
      listener();
    }
    
  }


  @override void dispose() {
    super.dispose();
    _listeners.clear();
  }
}