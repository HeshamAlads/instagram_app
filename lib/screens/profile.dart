import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_app/shared/cached_imgs.dart';
import 'package:instagram_app/shared/colors.dart';

class Profile extends StatefulWidget {
  final String uiddd;

  const Profile({Key? key, required this.uiddd}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map userDate = {};
  late bool isLoading;
  late int followers;
  late int following;
  late int postCount;
  late bool showFollow;

  getData() async {
    // Get data from DB
    setState(() {
      isLoading = true;
    });
    try {
      //  To get CurrentUser Data As DocumentSnapShot Data Type
      DocumentSnapshot<Map<String, dynamic>> snapShotUserData =
          await FirebaseFirestore.instance
              .collection('userSSS')
              .doc(widget.uiddd)
              .get();
      //  Convert DocumentSnapShot Data type To Map
      userDate = snapShotUserData.data()!;
      //  To get Followers Count
      followers = userDate["followers"].length;
      //  To get Following Count
      following = userDate["following"].length;
      //  Check user Uid == Current User Uid inSide Search Screen <<<<<<<
      showFollow = userDate["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);
      //  To get posts length by filter documents within a collection
      dynamic snapShotUserPostsData = await FirebaseFirestore.instance
          .collection('postSSS')
          .where("uid", isEqualTo: widget.uiddd)
          .get();
      //  get posts length
      postCount = snapShotUserPostsData.docs.length;
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(userDate["username"]),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    "assets/img/instagram.svg",
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: 35,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(125, 78, 91, 110),
                              ),
                              child: ImgApp().profileImg(
                                  profileImg: userDate["profileImg"],
                                  context: context),
                            ),
                            Text(
                              userDate["title"],
                              style: const TextStyle(color: Colors.white),
                              // textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  postCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Posts",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 17,
                            ),
                            Column(
                              children: [
                                Text(
                                  followers.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Followers",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 17,
                            ),
                            Column(
                              children: [
                                Text(
                                  following.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Following",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.20,
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  widget.uiddd == FirebaseAuth.instance.currentUser!.uid
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 25.0,
                              ),
                              label: const Text(
                                "Edit profile",
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(0, 90, 103, 223)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 33)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        color:
                                            Color.fromARGB(109, 255, 255, 255),
                                        // width: 1,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                FirebaseAuth.instance.authStateChanges();
                              },
                              icon: const Icon(
                                Icons.logout,
                                size: 25.0,
                              ),
                              label: const Text(
                                "Log out",
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(143, 255, 55, 112)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 33)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : showFollow
                          ? ElevatedButton(
                              onPressed: () async {
                                followers--;
                                setState(() {
                                  showFollow = false;
                                });
                                // widget.uiddd ==> الشخص الغريب
                                await FirebaseFirestore.instance
                                    .collection("userSSS")
                                    .doc(widget.uiddd)
                                    .update({
                                  "followers": FieldValue.arrayRemove(
                                      [FirebaseAuth.instance.currentUser!.uid])
                                });

                                await FirebaseFirestore.instance
                                    .collection("userSSS")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  "following":
                                      FieldValue.arrayRemove([widget.uiddd])
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(143, 255, 55, 112)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 66)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "unfollow",
                                style: TextStyle(fontSize: 17),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                followers++;
                                setState(() {
                                  showFollow = true;
                                });
                                // widget.uiddd ==> الشخص الغريب
                                await FirebaseFirestore.instance
                                    .collection("userSSS")
                                    .doc(widget.uiddd)
                                    .update({
                                  "followers": FieldValue.arrayUnion(
                                      [FirebaseAuth.instance.currentUser!.uid])
                                });
                                await FirebaseFirestore.instance
                                    .collection("userSSS")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  "following":
                                      FieldValue.arrayUnion([widget.uiddd])
                                });
                              },
                              style: ButtonStyle(
                                // backgroundColor: MaterialStateProperty.all(
                                //     Color.fromARGB(0, 90, 103, 223)),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 77)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Follow",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                  const SizedBox(
                    height: 9,
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.20,
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('postSSS')
                        .where("uid", isEqualTo: widget.uiddd)
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        List imgPost = snapshot.data!.docs;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8),
                                itemCount: imgPost.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: ImgApp().postImg(
                                        imgPost: imgPost[index]["imgPost"],
                                        context: context),
                                  );
                                }),
                          ),
                        );
                      }
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
