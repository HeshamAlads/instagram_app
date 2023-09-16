import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/firebase_services/firebase_store.dart';
import 'package:instagram_app/screens/comments.dart';
import 'package:instagram_app/shared/cached_imgs.dart';
import 'package:instagram_app/shared/heart_animation.dart';
import 'package:intl/intl.dart';

class PostDesign extends StatefulWidget {
  // Current Post
  final Map data;

  const PostDesign({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  int commentCount = 0;
  bool isLikeAnimating = false;

  getCommentCount() async {
    try {
      QuerySnapshot commentData = await FirebaseFirestore.instance
          .collection("postSSS")
          .doc(widget.data["postId"])
          .collection("commentSSS")
          .get();
      setState(() {
        commentCount = commentData.docs.length;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  showModel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialog(
              shadowColor: Colors.cyan,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.black,
              children: [
                FirebaseAuth.instance.currentUser!.uid == widget.data["uid"]
                    ? SizedBox(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SimpleDialogOption(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await FirebaseFirestore.instance
                                    .collection("postSSS")
                                    .doc(widget.data["postId"])
                                    .delete();
                              },
                              padding: const EdgeInsets.only(),
                              child: const Text(
                                "Delete Post",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SimpleDialogOption(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              padding: const EdgeInsets.only(),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SimpleDialogOption(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    // final double widthScreen = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: Column(
        children: [
          const Divider(
            indent: 6,
            endIndent: 6,
            thickness: 1,
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(125, 78, 91, 110),
                      ),
                      child: ImgApp().profileImg(
                          profileImg: widget.data["profileImg"],
                          context: context),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Text(
                      widget.data["username"],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      showModel();
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              await FireStoreMethods().toggleLike(postData: widget.data);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.data["imgPost"],
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: const Center(
                                child: CircularProgressIndicator()));
                  },
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 111,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.data['likes']
                          .contains(FirebaseAuth.instance.currentUser!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FireStoreMethods()
                              .toggleLike(postData: widget.data);
                        },
                        icon: widget.data['likes'].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                    data: widget.data,
                                    showTextField: true,
                                  )),
                        );
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_outline),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
            width: double.infinity,
            child: Text(
              "${widget.data["likes"].length} ${widget.data["likes"].length > 1 ? "Likes" : "Like"}      ",
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 9,
              ),
              Text(
                widget.data["username"],
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                // " ${widget.snap["description"]}",
                widget.data["description"],
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 189, 196, 199)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                    data: widget.data,
                    showTextField: false,
                  ),
                ),
              );
            },
            child: Container(
                margin: const EdgeInsets.fromLTRB(10, 13, 9, 10),
                width: double.infinity,
                child: Text(
                  "view all $commentCount comments",
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                  textAlign: TextAlign.start,
                )),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 9, 10),
              width: double.infinity,
              child: Text(
                DateFormat('hh:mm a,  MMMM d, ' 'y')
                    .format(widget.data["datePublished"].toDate()),
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                textAlign: TextAlign.start,
              )),
        ],
      ),
    );
  }
}
