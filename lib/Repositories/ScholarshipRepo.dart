import 'package:projectapp/Models/Scholarship.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectapp/Models/UserProfile.dart';

class ScholarshipRepo 
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


Future<List<Scholarship>> fetchMatchedScholarships(Userprofile userProfile) async {



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





  // Add a new scholarship and return the saved model (with generated id)
  Future<Scholarship> addNew(Scholarship scholarship) async {
    try {
      final Map<String, dynamic> data = scholarship.toMap();

      final DocumentReference docRef = await _firestore.collection('Scholarships').add(data);
      final DocumentSnapshot snap = await docRef.get();
      final Map<String, dynamic> saved = (snap.data() as Map<String, dynamic>?) ?? <String, dynamic>{};

      return Scholarship.fromMap(saved, docRef.id);
    } catch (e) {
      rethrow;
    }
  }



   Future<void> updateById(Scholarship scholarship) async {
    final DocumentReference docRef = _firestore.collection('Scholarships').doc(scholarship.id);
   
      try {
        await docRef.update(scholarship.toMap());
      } catch (e ) {
        print(e);
        throw Exception('Failed to update scholarship');
        
      }
    }


    Future<List<Scholarship>> getAllScholarships() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('Scholarships').get();
      return snapshot.docs.map((doc) {
        return Scholarship.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch scholarships');
    } 

 
 }




  






}