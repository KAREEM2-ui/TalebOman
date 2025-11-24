import 'dart:convert';

import 'package:projectapp/Models/Scholarship.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirestoreCache {

  // Singleton pattern ONLY one instance to save memory
  // SharedPreferences instance loads all stored cache into memory

  static SharedPreferences? cache;


  static Future<void> _init() async {
    cache = await SharedPreferences.getInstance();
  }


  static Future<void> _removeAllCache() async {

    await cache!.clear();
  }

  static Future<void> updateScholarshipsMatchedList(List<Scholarship> scholarship) async {
    
    // remove previous cache , if any
    if(cache != null)
    {
      await _removeAllCache();
    }


    if(cache == null)
    {
      await _init();
    }

    String jsonList = jsonEncode({
      'retryAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(), // retry fetching after 1 hour 
      'data': scholarship.map<Map<String, dynamic>>((scholarship) => {...scholarship.toMap(), "deadline" : scholarship.deadline.toIso8601String(),"id" : scholarship.id!}).toList(),
    });

    await cache!.setString('matched_scholarships', jsonList);
    

    
  }


  static Future<List<Scholarship>?> getScholarshipsMatchedList() async {
    if(cache == null)
    {
      await _init();
    }

    

    String? jsonString = cache!.getString('matched_scholarships');

    // no cache found
    if(jsonString == null)
    {
      return null;
    }

    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    // check if cache is expired
    DateTime retryAt = DateTime.parse(jsonMap['retryAt'] as String);
    if(DateTime.now().isAfter(retryAt))
    {
      return null;
    }

    List<dynamic> dataList = jsonMap['data'] as List<dynamic>;

    List<Scholarship> scholarships = dataList.map<Scholarship>((data) => Scholarship.fromMap(data as Map<String, dynamic>, data['id'] as String)).toList();

    return scholarships;
  }
}