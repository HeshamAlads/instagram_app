import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/provider/user_provider.dart';
import 'package:instagram_app/screens/add_post.dart';
import 'package:instagram_app/screens/home.dart';
import 'package:instagram_app/screens/profile.dart';
import 'package:instagram_app/screens/search.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  // To get data from DB using provider
  getDataFromDB() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
          // iconSize: 33,
          height: 68,
          activeColor: primaryColor,
          inactiveColor: secondaryColor,
          backgroundColor: mobileBackgroundColor,
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            // navigate to the taped page
            setState(() {
              _pageController.jumpToPage(index);
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_search_rounded,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_photo_alternate_outlined,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_outlined,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: ""),
          ]),
      body: PageView(
        // physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          print("------- $index");
          selectedIndex = index;
          // navigate to the taped page
          setState(() {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
            );
          });
        },
        controller: _pageController,
        children: [
          const Home(),
          const Search(),
          const AddPost(),
          const Center(
            child: Text("Love u ♥"),
          ),
          Profile(uiddd: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
    );
  }
}
