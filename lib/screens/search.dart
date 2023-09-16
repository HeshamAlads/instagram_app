import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/screens/profile.dart';
import 'package:instagram_app/shared/cached_imgs.dart';
import 'package:instagram_app/shared/colors.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(showUser);
  }

  showUser() {
    setState(() {});
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_outlined),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: TextFormField(
              controller: myController,
              decoration: const InputDecoration(
                labelText: 'Search for a user...',
                prefixIcon: Icon(Icons.search_outlined),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('userSSS')
              .where("username", isEqualTo: myController.text)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              List allUserNames = snapshot.data!.docs;
              return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allUserNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(
                                uiddd: allUserNames[index]["uid"],
                              ),
                            ),
                          );
                        },
                        title: Text(allUserNames[index]["username"]),
                        leading: ImgApp().profileImg(
                            profileImg: allUserNames[index]["profileImg"],
                            context: context),
                      ),
                    );
                  });
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          },
        ));
  }
}
