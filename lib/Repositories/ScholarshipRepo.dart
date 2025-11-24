import 'package:projectapp/Models/Scholarship.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectapp/Models/UserProfile.dart';

class ScholarshipRepo 
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


Future<List<Scholarship>> fetchScholarships(Userprofile userProfile) async {



  // Start base query
  Query query = _firestore.collection('Scholarships');

  


  // Qualification field (array)
  // it will make an index only for the specific field of the user

  query = query.where("fieldsOfStudy", arrayContains: userProfile.fieldOfInterest);



  // English proficiency 
  query = query.where("minIelts", isLessThanOrEqualTo: userProfile.ieltsScore);


  // CGPA
  query = query.where("minCgpa", isLessThanOrEqualTo: userProfile.cgpa);

  // deadline not passed
  DateTime now = DateTime.now();
  query = query.where("deadline", isGreaterThan: Timestamp.fromDate(now));

  // Execute query
  QuerySnapshot<Object?> querySnapshot = await query.get();
  
  // Map to Scholarship objects
  return querySnapshot.docs.map((doc) {
    return Scholarship.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }).toList();
}


}