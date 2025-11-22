class UserDetails {
  String uid;
  String role;
  String? token;

  UserDetails({required this.uid,required this.role, this.token});

  factory UserDetails.fromMap(Map<String,dynamic> map, String id)
  {
    return UserDetails(
      uid: id,
      role: map['role'] as String,
      token: map['token'] as String?,
    );
  }
}
