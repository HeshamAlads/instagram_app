import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/post_design.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.messenger_outline,
                color: primaryColor,
              )),
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                FirebaseAuth.instance.authStateChanges();
              },
              icon: const Icon(
                Icons.logout,
              )),
        ],
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/img/instagram.svg",
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 35,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('postSSS')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        // dataPublished
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ));
          }

          ///  Don't Forget Convert This ListView To ListView.builder <<<<<<<
          ///   عدد البوستات اقدر استخدمها مع (ListView.builder) = snapshot.data!.docs.asMap  ///

          List<QueryDocumentSnapshot<dynamic>> posts = snapshot.data!.docs;
          return posts.isEmpty
              ? const Center(
            child: Text(
              'No Posts Yet',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            ),
          )
              : ListView(
            children:

            posts.map((QueryDocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              return PostDesign(
                data: data,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
