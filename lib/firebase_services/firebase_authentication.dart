import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/firebase_services/firebase_storage.dart';
import 'package:instagram_app/main.dart';
import 'package:instagram_app/models/user_data.dart';
import 'package:instagram_app/shared/snackbar.dart';

class AuthMethods {
  String? message;

  newRegisterUser({
    required emailll,
    required passworddd,
    required context,
    required titleee,
    required usernameee,
    required imgName,
    required imgPath,
  }) async {
    message = "ERROR => Not starting the createUserWithEmailAndPassword";
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailll,
        password: passworddd,
      );
      message = "ERROR => Registered only Without set FireStore Collection";
// ______________________________________________________________________
      String urlll = await getImgURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'ProfileIMG/${FirebaseAuth.instance.currentUser!.uid}');
// _______________________________________________________________________
// firebase firestore (Database)
      CollectionReference users =
          FirebaseFirestore.instance.collection('userSSS');
      UserData userr = UserData(
        email: emailll,
        password: passworddd,
        title: titleee,
        username: usernameee,
        profileImg: urlll,
        uid: credential.user!.uid,
        followers: [],
        following: [],
      );
      users
          .doc(credential.user!.uid)
          .set(userr.convert2Map())
          .then((value) => debugPrint("User Added"))
          .catchError((error) => debugPrint("Failed to add user: $error"));
      message = " Registered Successfully & User Added To DataB ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context, "ERROR: ${e.code} \n message: ${message = e.toString()} ");
    } catch (e) {
      debugPrint("Error: $e \n message: $message");
    }
    showSnackBar(context, message!);
    debugPrint("message: $message");
  }

  signIn({required emailll, required passworddd, required context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailll, password: passworddd);
      // To Listen FirebaseAuth instance authStateChanges //
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
      showSnackBar(context, "successfully sign-in ☺");
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        "ERROR :  ${e.code}",
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Function to get user details from Firestore (Database)
  Future<UserData> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('userSSS')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserData.convertSnap2Model(snap);
  }
}
