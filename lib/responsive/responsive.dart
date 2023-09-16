// // ignore_for_file: prefer_const_constructors
//
// import 'package:flutter/material.dart';
// import 'package:instagram_app/responsive/main_screen.dart';
// import 'package:instagram_app/responsive/web.dart';
//
// class Responsive extends StatefulWidget {
//   final MyWebScreen myMobileScreen;
//   final MyMobileScreen myWebScreen;
//   const Responsive(
//       {super.key, required this.myMobileScreen, required this.myWebScreen});
//
//   @override
//   State<Responsive> createState() => _ResponsiveState();
// }
//
// class _ResponsiveState extends State<Responsive> {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         if (constraints.maxWidth > 600) {
//           return MyWebScreen();
//         } else {
//           return MyMobileScreen();
//         }
//       },
//     );
//   }
// }
