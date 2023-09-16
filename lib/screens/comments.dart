import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/firebase_services/firebase_store.dart';
import 'package:instagram_app/provider/user_provider.dart';
import 'package:instagram_app/shared/cached_imgs.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Don't Forget Functionality Heart Like Button
class CommentsScreen extends StatefulWidget {
  // data of clicked post
  final Map data;
  final bool showTextField;

  const CommentsScreen(
      {Key? key, required this.data, required this.showTextField})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Comments',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('postSSS')
                .doc(widget.data["postId"])
                .collection("commentSSS")
                .orderBy('datePublished', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              ///   عدد الكومنتات اقدر استخدمها مع (ListView.builder) = snapshot.data!.docs.asMap  ///
              ///  List allComments = snapshot.data!.docs.cast();
              ///  List allComments = snapshot.data!.docs;
              List allComments = snapshot.data!.docs;
              return Expanded(
                child: allComments.isEmpty
                    ? const Center(
                        child: Text(
                          'No Comments Yet',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: allComments.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(left: 8, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(125, 78, 91, 110),
                                      ),
                                      child: ImgApp().profileImg(
                                        profileImg:
                                            allComments[index]!["profilePic"],
                                        radius: 20,
                                        context: context,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                allComments[index]!["username"],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17)),
                                            const SizedBox(
                                              width: 11,
                                            ),
                                            //////////// time
                                            Text(
                                              DateFormat('hh:mm a').format(
                                                allComments[index]![
                                                        "datePublished"]
                                                    .toDate(),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          allComments[index]!["textComment"],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.favorite))
                              ],
                            ),
                          );
                        },
                      ),
              );
            },
          ),
          widget.showTextField
              ? Container(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                    right: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(125, 78, 91, 110),
                        ),
                        child: ImgApp().profileImg(
                          profileImg: userData!.profileImg,
                          context: context,
                          radius: 20,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 35),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: "Add Comment As ${userData.username}  ",
                            suffixIcon: IconButton(
                              onPressed: () async {
                                await FireStoreMethods().uploadComment(
                                    commentText: commentController.text,
                                    postId: widget.data["postId"],
                                    profileImg: userData.profileImg,
                                    username: userData.username,
                                    uid: userData.uid);

                                commentController.clear();
                              },
                              icon: const Icon(Icons.send),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
