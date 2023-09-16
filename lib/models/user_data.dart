import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String email;
  final String password;
  final String username;
  final String title;
  final String profileImg;
  final List followers;
  final List following;

  UserData({
    required this.uid,
    required this.email,
    required this.password,
    required this.username,
    required this.title,
    required this.profileImg,
    required this.followers,
    required this.following,
  });

// To convert the UserData(Data type) to   Map<String, Object>
  Map<String, dynamic> convert2Map() {
    return {
      "uid": uid,
      "email": email,
      "password": password,
      "username": username,
      "title": title,
      "profileImg": profileImg,
      "followers": [],
      "following": []
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      uid: snapshot['uid'],
      email: snapshot['email'],
      password: snapshot['password'],
      username: snapshot['username'],
      title: snapshot['title'],
      profileImg: snapshot['profileImg'],
      followers: ['followers'],
      following: snapshot['following'],
    );
  }
}
