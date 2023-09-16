import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/firebase_services/firebase_store.dart';
import 'package:instagram_app/main.dart';
import 'package:instagram_app/provider/user_provider.dart';
import 'package:instagram_app/shared/cached_imgs.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/snackbar.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final desController = TextEditingController();
  Uint8List? imgPath;
  String? imgName;

  bool isLoading = false;

  uploadImage2Screen(ImageSource source) async {
    // Navigator.pop(context);
    final XFile? pickedImg = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        setState(() {
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
        });
        // Image compress function
        imgPath = await FlutterImageCompress.compressWithFile(
          imgName!,
          format: CompressFormat.heic,
        );
      } else {
        print("NO img selected");
        if (!mounted) return;
        showSnackBar(context, 'NO Img Selected');
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  showModel() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shadowColor: Colors.cyan,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                await uploadImage2Screen(ImageSource.camera);
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "From Camera",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                await uploadImage2Screen(ImageSource.gallery);
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "From Gallery",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ////////// Provider /////////
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;
    return imgPath == null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: IconButton(
                  onPressed: () async {
                    await showModel();
                  },
                  icon: const Icon(
                    Icons.upload,
                    size: 55,
                  )),
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await FireStoreMethods().uploadPost(
                          imgName: imgName,
                          imgPath: imgPath,
                          description: desController.text,
                          profileImg: allDataFromDB!.profileImg,
                          username: allDataFromDB.username,
                          context: context);

                      setState(() {
                        isLoading = false;
                        imgPath = null;
                        desController.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                        );
                      });
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    )),
              ],
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      isLoading = false;
                      imgPath = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Column(
                    children: [
                      isLoading
                          ? const LinearProgressIndicator()
                          : const Divider(
                              thickness: 1,
                            ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(125, 78, 91, 110),
                                ),
                                child: ImgApp().profileImg(
                                    profileImg: allDataFromDB!.profileImg,
                                    context: context),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: SizedBox(
                                  // width: MediaQuery.of(context).size.width,
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: desController,
                                    decoration: const InputDecoration(
                                      hintText: "write a caption...",
                                      // border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.only(left: 35),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      isLoading
                          ? const LinearProgressIndicator()
                          : const Divider(
                              thickness: 1,
                            ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(imgPath!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
