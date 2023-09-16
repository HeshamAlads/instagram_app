import 'package:flutter/material.dart';
import 'package:instagram_app/firebase_services/firebase_authentication.dart';
import 'package:instagram_app/models/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;

  UserData? get getUser => _userData;

  refreshUser() async {
    UserData userData = await AuthMethods().getUserDetails();
    _userData = userData;
    notifyListeners();
  }
}
