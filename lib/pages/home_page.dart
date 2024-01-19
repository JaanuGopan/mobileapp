import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartgarden/auth/login_or_register.dart';
import 'package:smartgarden/components/post.dart';
import 'package:smartgarden/components/post_list.dart';
import 'package:smartgarden/components/statusbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _currentIndex = 0;

  var postList;

  @override
  void initState() {
    // TODO: implement initState
    fetchPostData();
    super.initState();
  }

  Future<void> fetchPostData() async {
    // Retrieve a limited number of random posts
    var randomPosts = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp') // Use a field for ordering, like timestamp
        .limit(15) // Adjust the limit based on your requirements
        .get();

    // Shuffle the list of random posts
    var shuffledPosts = randomPosts.docs.toList()..shuffle();
    setState(() {
      postList = shuffledPosts;
    });

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/background3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Main Page Content
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                      height: screenHeight * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.99),
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              StatusBar(),

                             if(postList != null) ... {
                               for(var post in postList)...{
                                  Post(postConst: post,),
                               }
                             }

                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
