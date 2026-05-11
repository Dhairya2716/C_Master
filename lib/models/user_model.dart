class UserModel {

  final String uid;
  final String email;
  final String name;
  final String createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
});

  Map<String, dynamic> toMap(){

    return{
      'uid':uid,
      'email':email,
      'name':name,
      'createdAt':createdAt,
    };

  }

  factory UserModel.fromMap(Map<String, dynamic> map){

    return UserModel(
      uid: map['uid'],
      email: map['map'],
      name: map['name'],
      createdAt: map['createdAt']
    );

  }

}