import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgarden/components/button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection("users");

  String? imageUrl;
  String? imageCaption;
  bool isLoading = false;
  XFile? selectedImageFile;

  @override
  void initState() {
    super.initState();
    fetchProfilePicture(); // Fetch profile picture when the page initializes
  }

  Future<void> fetchProfilePicture() async {
    try {
      DocumentSnapshot userSnapshot =
      await usersCollection.doc(user.uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('profilePicture') && userData.containsKey('userName')) {
          setState(() {
            imageUrl = userData['profilePicture'];
            imageCaption = userData['userName'];
          });
        }
      }
    } catch (error) {
      print("Error fetching profile picture: $error");
    }
  }

  void selectCameraOrGallery(bool cameraOrGallery) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(
      source: cameraOrGallery ? ImageSource.camera : ImageSource.gallery,
    );

    if (imageFile != null) {
      setState(() {
        selectedImageFile = imageFile;
      });
      uploadProfilePhoto();
    }
  }

  Future<void> uploadProfilePhoto() async {
    if (selectedImageFile == null) {
      return;
    }

    try {
      setState(() {
        isLoading = true; // Set loading to true when starting image upload
      });

      String uniqueFileName = 'profile_${user.uid.toString()}.jpeg';

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('profile_images');
      Reference referenceImageToUpload =
      referenceDirImages.child(uniqueFileName);

      await referenceImageToUpload.putFile(File(selectedImageFile!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();

      // Update profilePhoto field in Firestore for the current user
      await usersCollection.doc(user.uid).update({'profilePicture': imageUrl});
    } catch (error) {
      print("Error uploading image: $error");
      // You can add additional error handling if needed
    } finally {
      setState(() {
        isLoading = false; // Set loading to false when image upload is complete
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: selectedImageFile != null
                                      ? Image.file(
                                    File(selectedImageFile!.path),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  )
                                      : imageUrl != null
                                      ? Image.network(
                                    imageUrl!,
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  )
                                      : Image(
                                    image: AssetImage(
                                        "lib/assets/profile.png"),
                                    height: 300,
                                    width: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 160,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Color(0xFF207D4A),
                                  size: 30,
                                ),
                                onPressed: () {
                                  selectCameraOrGallery(false);
                                },
                              ),
                            ),
                            isLoading
                                ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF207D4A),
                              ),
                            )
                                : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: 10,
                                height: 10,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${imageCaption != null ? imageCaption : ""}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF207D4A),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              "Posts",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF207D4A),
                              ),
                            ),
                          ],
                        ),
                      ],
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
