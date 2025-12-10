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

  Future<int> getTotalUserProfilesCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('UserProfiles').get();
      return snapshot.size;
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch user profiles count');
    }
  }


  Future<int> fetchAlertsCount(String userId) async {
    try {
      AggregateQuerySnapshot res = await _firestore.collection('Alerts').doc(userId).collection("UserAlerts").where('isRead', isEqualTo: false).count().get();
      if (res.count != null) {
        return res.count!;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to fetch alerts count');
    }
  }

  Future<void> markAllAsRead(String userId) async
  {
    try {
      WriteBatch batch = _firestore.batch();
      QuerySnapshot snapshot = await _firestore.collection('Alerts').doc(userId).collection("UserAlerts").where('isRead', isEqualTo: false).get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      print(e);
      throw Exception('Failed to mark alerts as read');
    }
  }
}