// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:instagram_app/screens/add_post.dart';
// import 'package:instagram_app/screens/home.dart';
// import 'package:instagram_app/screens/profile.dart';
// import 'package:instagram_app/screens/search.dart';
// import 'package:instagram_app/shared/colors.dart';
//
// class MyWebScreen extends StatefulWidget {
//   const MyWebScreen({super.key});
//
//   @override
//   State<MyWebScreen> createState() => _MyWebScreenState();
// }
//
// class _MyWebScreenState extends State<MyWebScreen> {
//   final PageController _pageController = PageController();
//   int selectedIndex = 0;
//
//   navigate2Screen(int index) {
//     _pageController.jumpToPage(index);
//     setState(() {
//       selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.home,
//               color: selectedIndex == 0 ? primaryColor : secondaryColor,
//             ),
//             onPressed: () {
//               navigate2Screen(0);
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.search,
//               color: selectedIndex == 1 ? primaryColor : secondaryColor,
//             ),
//             onPressed: () {
//               navigate2Screen(1);
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.add_a_photo,
//               color: selectedIndex == 2 ? primaryColor : secondaryColor,
//             ),
//             onPressed: () {
//               navigate2Screen(2);
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.favorite,
//               color: selectedIndex == 3 ? primaryColor : secondaryColor,
//             ),
//             onPressed: () {
//               navigate2Screen(3);
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.person,
//               color: selectedIndex == 4 ? primaryColor : secondaryColor,
//             ),
//             onPressed: () {
//               navigate2Screen(4);
//             },
//           ),
//         ],
//         backgroundColor: mobileBackgroundColor,
//         title: SvgPicture.asset(
//           "assets/img/instagram.svg",
//           color: primaryColor,
//           height: 32,
//         ),
//       ),
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: (index) {
//
//         },
//         physics: NeverScrollableScrollPhysics(),
//         // controller: _pageController,
//         children: [
//           Home(),
//           Search(),
//           AddPost(),
//           Center(child: Text("Love u ♥")),
//           Profile(),
//         ],
//       ),
//     );
//   }
// }
