import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgarden/components/post_list.dart';

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
  bool isLoadingProfilePhoto = false;
  bool isLoadingCaption = false;
  XFile? selectedImageFile;
  Map<String, dynamic>? userDataForPost;

  @override
  void initState() {
    super.initState();
    fetchProfileData(); // Fetch profile data when the page initializes
  }

  Future<void> fetchProfileData() async {
    try {
      // Fetch profile photo
      DocumentSnapshot userSnapshot = await usersCollection.doc(user.uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('profilePicture') &&
            userData.containsKey('userName')) {
          setState(() {
            imageUrl = userData['profilePicture'];
            isLoadingProfilePhoto =
            false; // Set loading to false when data is loaded
            userDataForPost = userData;
          });
        }
      }

      // Fetch photo caption
      setState(() {
        isLoadingCaption = true; // Set loading to true while fetching caption
      });

      DocumentSnapshot captionSnapshot =
      await usersCollection.doc(user.uid).get();

      if (captionSnapshot.exists) {
        Map<String, dynamic> captionData =
        captionSnapshot.data() as Map<String, dynamic>;

        if (captionData.containsKey('userName')) {
          setState(() {
            imageCaption = captionData['userName'];
            isLoadingCaption =
            false; // Set loading to false when data is loaded
          });
        }
      }
    } catch (error) {
      print("Error fetching profile data: $error");
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
        isLoadingProfilePhoto =
        true; // Set loading to true when starting image upload
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
        isLoadingProfilePhoto =
        false; // Set loading to false when image upload is complete
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
            child: Container(
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
                                    : isLoadingProfilePhoto
                                    ? CircularProgressIndicator(
                                  color: Color(0xFF207D4A),
                                )
                                    : imageUrl != null
                                    ? Image.network(
                                  imageUrl!,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  width: 300,
                                  height: 300,
                                  color: Color(0xFFC7DED2),
                                  child:
                                  CircularProgressIndicator(
                                    color: Color(0xFF207D4A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            left: 220,
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
                          isLoadingProfilePhoto
                              ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 10,
                              height: 10,
                            ),
                          )
                              : Container()
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isLoadingCaption
                          ? CircularProgressIndicator(
                        color: Color(0xFF207D4A),
                      )
                          : Text(
                        "${imageCaption != null ? imageCaption : ""}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
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
                      // Dynamically create PostList widgets
                      if (imageUrl != null) ...{
                        for (int i = 0; i < userDataForPost!['posts'].length; i++)
                          PostList(userID: user.uid, postIndex: i),
                      }
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
