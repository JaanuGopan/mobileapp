import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartgarden/components/edit_post.dart';

class PostList extends StatefulWidget {
  final String userID;
  final int postIndex;

  const PostList({super.key, required this.userID, required this.postIndex});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  String? postUrl;
  String? postCaption;
  bool isLoading = true; // Add loading state
  bool isPhostImageLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProfilePicture(); // Fetch profile picture when the page initializes
  }

  Future<void> fetchProfilePicture() async {
    try {
      setState(() {
        isPhostImageLoading = true;
      });
      DocumentSnapshot userSnapshot =
          await usersCollection.doc(widget.userID).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Assuming userData['posts'] is not null and is an array
        if (userData.containsKey('posts') && userData['posts'].isNotEmpty) {
          // Get the first post
          Map<String, dynamic> firstPost = userData['posts'][widget.postIndex];

          // Check if the post has 'imageUrl' and 'caption' fields
          if (firstPost.containsKey('imageUrl') &&
              firstPost.containsKey('caption')) {
            setState(() {
              postUrl = firstPost['imageUrl'];
              postCaption = firstPost['caption'];
              isLoading = false; // Set loading to false when data is loaded
            });
          }
        }
      }
    } catch (error) {
      print("Error fetching profile picture: $error");
      setState(() {
        isLoading = false; // Set loading to false in case of an error
      });
    } finally {
      setState(() {
        isPhostImageLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: isPhostImageLoading
                          ? CircularProgressIndicator(
                              color: Color(0xFF207D4A),
                            )
                          : Image.network(
                              postUrl.toString(),
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
                      Icons.edit_document,
                      color: Color(0xFF207D4A),
                      size: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditPostOverlay(
                            userId: widget.userID,
                            postindex: widget.postIndex,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
      ),
    );
  }
}
