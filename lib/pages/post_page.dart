import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgarden/components/button.dart';

import '../components/text_field.dart';
import '../models/Post.dart' as model;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection("posts");

  final _captionTextController = TextEditingController();

  String? imageUrl;
  bool isLoading = false;
  XFile? selectedImageFile;

  void selectCameraOrGallery(bool cameraOrGallery) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(
        source: cameraOrGallery ? ImageSource.camera : ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        selectedImageFile = imageFile;
      });
    }
  }

  Future<void> uploadPost() async {
    if (selectedImageFile == null) {
      // No image selected
      String msg = "please select the image";
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
              msg.toString(),
              style: TextStyle(color: Color(0xFF207D4A), fontSize: 20),
            ));
          });
    }

    try {
      setState(() {
        isLoading = true; // Set loading to true when starting image upload
      });

      String uniqueFileName =
          'post_${user.uid.toString()}${DateTime.now().microsecondsSinceEpoch.toString()}.jpeg';

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('posts');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      await referenceImageToUpload.putFile(File(selectedImageFile!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      String imagecaption = _captionTextController.text.trim();
      //upload the post to users collection

// Create a new post map
      // Create a new post map
      Map<String, dynamic> newPost = {
        'imageUrl': imageUrl!,
        'caption': imagecaption,
      };

// Update the posts field in Firestore with the new post
      await usersCollection.doc(user.uid).update({
        'posts': FieldValue.arrayUnion([newPost]),
      });
      List<model.Post> postsList = [
        model.Post(
          imageUrl: imageUrl!,
          caption: imagecaption,
          userId: user.uid,
          timestamp: Timestamp.now(),
        ),
        // Add more posts as needed
      ];

      for (model.Post post in postsList) {
        postsCollection.add({
          'imageUrl': post.imageUrl,
          'caption': post.caption,
          'userId': post.userId,
          'timestamp': post.timestamp,
        });
      }
    } catch (error) {
      print("Error uploading image: $error");
      // You can add additional error handling if needed
    } finally {
      setState(() {
        isLoading = false; // Set loading to false when image upload is complete
        selectedImageFile = null;
        _captionTextController.text = "";
        String msg = "Post successfully uploaded..";
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  content: Text(
                msg.toString(),
                style: TextStyle(color: Color(0xFF207D4A), fontSize: 20),
              ));
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
            child: Stack(
              children: [
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.97),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 5.0,
                      bottom: 16.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Create your post here",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF207D4A),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // Display the selected image
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFC7DED2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: selectedImageFile != null
                                      ? Image.file(
                                          File(selectedImageFile!.path),
                                          width: 250,
                                          height: 250,
                                        )
                                      : Image(
                                          image: AssetImage(
                                              "lib/assets/post2.png"),
                                          height: 250,
                                          width: 250,
                                        ),
                                ),
                              ),
                            ],
                          ),

                          // Loading indicator while uploading
                          isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                )
                              : Container(),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFC7DED2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.image_outlined,
                                      color: Color(0xFF207D4A),
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      selectCameraOrGallery(false);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFC7DED2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Color(0xFF207D4A),
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      selectCameraOrGallery(true);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                "Caption",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF207D4A),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          MyTextField(
                            controller: _captionTextController,
                            hintText: "Insert Caption",
                            obscureText: false,
                            icon: Icon(Icons.comment),
                            width: screenWidth * 0.8,
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          Container(
                              width: 100,
                              height: 60,
                              child: MyButton(onTap: uploadPost, text: "Post")),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
