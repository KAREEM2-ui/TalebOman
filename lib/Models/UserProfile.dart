class Userprofile 
{
  String fullName;
  String? fieldOfInterest;
  double cgpa;
  double ieltsScore;


  Userprofile({
    required this.fullName,
    required this.fieldOfInterest,
    required this.cgpa,
    required this.ieltsScore,
  });

   Userprofile copy() => Userprofile(
    fullName: fullName,
    fieldOfInterest: fieldOfInterest,
    cgpa: cgpa,
    ieltsScore: ieltsScore,
  );

  factory Userprofile.newUserProfile() {
    return Userprofile(
      fullName: '',
      fieldOfInterest: null,
      cgpa: 0.0,
      ieltsScore: 0.0,
    );
  }
  
  


  factory Userprofile.fromMap(Map<String, dynamic> map) {
    return Userprofile(
      fullName: map['fullName'] as String,
      fieldOfInterest: map['fieldOfInterest'] as String,
      cgpa: map['cgpa'] as double,
      ieltsScore: map['ieltsScore'] as double,
    );
  }

 Map<String, dynamic> toMap() {
  return {
    'fullName': fullName,
    'fieldOfInterest': fieldOfInterest,
    'cgpa': cgpa,
    'ieltsScore': ieltsScore,
  };
}
}