import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/UserProfile.dart';


class UserProfileRepo 
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<Userprofile?> fetchUserProfile(String userId) async 
  {
      try
      {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('UserProfiles').doc(userId).get();
      if (!doc.exists) 
      {
        return null;
      }



      return Userprofile.fromMap(doc.data()!);  
      }
      catch(e)
      {
        throw Exception('Failed to fetch user profile: $e');
      }
  }


  Future<void> updateUserProfile(String userId, Userprofile userProfile) async {
    await _firestore.collection('UserProfiles').doc(userId).set(userProfile.toMap());
  }
}