import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Post.dart' as model;

class Post extends StatefulWidget {

  final postConst;
  const Post({Key? key,required this.postConst}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection("users");

  String? postUrl;
  String? postCaption;
  Timestamp? timestamp;
  String? profileId;
  String? profilePicUrl;
  String? profileName;

  bool isLoading = true; // Add loading state


  @override
  void initState() {
    super.initState();
    fetchProfilePicture(); // Fetch profile picture when the page initializes
  }

  Future<void> fetchProfilePicture() async {
    try {
      DocumentSnapshot userSnapshot =
      await usersCollection.doc(widget.postConst.data()['userId']).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;

        // Assuming userData['posts'] is not null and is an array
        if (widget.postConst != null) {
          // Get the first post
          setState(() {
            postUrl = widget.postConst.data()['imageUrl'];
            postCaption = widget.postConst.data()['caption'];
            profileName = userData['userName'];
            profilePicUrl = userData['profilePicture'];
            isLoading = false; // Set loading to false when data is loaded
          });
        }
      }
    } catch (error) {
      print("Error fetching profile picture: $error");
      setState(() {
        isLoading = false; // Set loading to false in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFC7DED2),
                ),
            child: Center(
                  child: CircularProgressIndicator(
            color: Color(0xFF207D4A),
                  ),
                ),
          ),
        ): Padding(
      padding:
          const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      profilePicUrl.toString(),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  profileName!.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF207D4A),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                postUrl.toString(),
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    color: Color(0xFF207D4A),
                    size: 30,
                  ),
                  onPressed: (){

                  },
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(
                    Icons.comment_bank_outlined,
                    color: Color(0xFF207D4A),
                    size: 30,
                  ),
                  onPressed: (){

                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                IconButton(
                    onPressed: () {

                    },
                    icon: Icon(
                      Icons.bookmark_border_outlined,
                      color: Color(0xFF207D4A),
                      size: 30,
                    ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          // Action Button (e.g., Add Plan)
          // ...
          // Example Plan List (Replace with your actual content)
          // ...
        ],
      ),
    );
  }
}
