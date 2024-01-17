import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostList extends StatefulWidget {
  final String userID;

  const PostList({super.key, required this.userID});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection("users");

  String? postUrl;
  String? postCaption;
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    fetchProfilePicture(); // Fetch profile picture when the page initializes
  }

  Future<void> fetchProfilePicture() async {
    try {
      DocumentSnapshot userSnapshot =
      await usersCollection.doc(widget.userID).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('posts')) {
          setState(() {
            postUrl = userData['posts'][0];
            postCaption = userData['posts'][1];
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
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFC7DED2),
      ),
      child: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color(0xFF207D4A),
        ),
      )
          : Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Image.network(
            postUrl.toString(),
            height: 70,
            width: 70,
          ),
          Text(
            postCaption.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Color(0xFF207D4A),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit_calendar_outlined,
              color: Color(0xFF207D4A),
              size: 30,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
