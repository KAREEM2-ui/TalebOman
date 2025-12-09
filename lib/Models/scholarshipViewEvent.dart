import 'package:cloud_firestore/cloud_firestore.dart';

class ScholarshipViewEvent {


  String scholarshipId;
  DateTime viewedAt;

  ScholarshipViewEvent({required this.scholarshipId, required this.viewedAt});


  factory ScholarshipViewEvent.fromMap(Map<String, dynamic> map) {
    return ScholarshipViewEvent(
      scholarshipId: map['scholarship_id'] as String,
      viewedAt: (map['viewed_at'] as Timestamp).toDate(),
    );
  }

}