import 'package:cloud_firestore/cloud_firestore.dart';

class Scholarship {
  String? id;
  final String Title;
  final String university;
  final String country;
  final String type;
  final List<String> coverage;
  final double minCGPA;
  final double minIelts;
  final DateTime deadline;
  final List<String> fieldsOfStudy;
  double? percentageScore;


  Scholarship({
    this.id,
    required this.Title,
    required this.university,
    required this.country,
    required this.type,
    required this.coverage,
    required this.minCGPA,
    required this.minIelts,
    required this.deadline, 
    required this.fieldsOfStudy,
  });

  factory Scholarship.fromMap(Map<String, dynamic> map,String id) {
    return Scholarship(
      id: id,
      Title: map['title'] as String,
      university: map['university'] as String,
      country: map['country'] as String,
      type: map['type'] as String,
      coverage: List<String>.from(map['coverage'] as List<dynamic>),
      minCGPA: (map['minCgpa'] as num).toDouble(),
      minIelts: (map['minIelts'] as num).toDouble(),

      // Handle both Timestamp (firestore) and string formats (in memory cache)
      deadline: map['deadline'] is Timestamp ? (map['deadline'] as Timestamp).toDate() : DateTime.parse(map['deadline'] as String),
      fieldsOfStudy: List<String>.from(map['fieldsOfStudy'] as List<dynamic>),
    );
  }
      
  

  Map<String, dynamic> toMap() {
    return {
      'title': Title,
      'minIelts': minIelts,
      'deadline': Timestamp.fromDate(deadline),
      'university': university,
      'country': country,
      'type': type,
      'coverage': coverage,
      'minCgpa': minCGPA,
      'fieldsOfStudy': fieldsOfStudy,
      
    };
  }

  // // Helper method to convert Map<dynamic, dynamic> to Map<String, bool>
  // static Map<String, bool>? _convertToBoolMap(dynamic value) {
  //   if (value == null) return null;
  //   if (value is Map) {
  //     return value.map((key, value) => MapEntry(key.toString(), value as bool));
  //   }
  //   return null;
  // }
}