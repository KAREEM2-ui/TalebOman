import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectapp/Models/scholarshipViewEvent.dart';


class AnalyticsRepo {
  // analytics for firebase console
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // firestore collection for custom analytics storage
  final CollectionReference _firestoreAnalytics = FirebaseFirestore.instance.collection("analytics").doc("events").collection("scholarship_viewed");

  

  Future<void> logScholarshipsViewed(List<String> scholarshipIds) async {


    for(String id in scholarshipIds) {
      await _analytics.logEvent(
        name: 'scholarship_viewed',
        parameters: {'scholarship_id': id},
      );
    }

    final batch = FirebaseFirestore.instance.batch();
    for (String id in scholarshipIds) {
      final docRef = _firestoreAnalytics.doc();
      batch.set(docRef, {
        'scholarship_id': id,
        'viewed_at': FieldValue.serverTimestamp(),
      });
    }


    await batch.commit();


  }

  Future<List<ScholarshipViewEvent>> getLatestsScholarshipsViewed(DateTime since) async {
    QuerySnapshot querySnapshot = await _firestoreAnalytics
        .where('viewed_at', isGreaterThan: Timestamp.fromDate(since))
        .get();

    List<ScholarshipViewEvent> viewEvents = querySnapshot.docs.map((doc) {
      return ScholarshipViewEvent.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();


    return viewEvents;



    
  }


}