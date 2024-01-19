import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgarden/components/button.dart';
import 'package:smartgarden/components/text_field.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  String? imageUrl;
  String? imageCaption;
  bool isLoadingProfilePhoto = false;
  bool isLoadingCaption = false;
  XFile? selectedImageFile;
  Map<String, dynamic>? userDataForEditProfile;

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
            userDataForEditProfile = userData;
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

  final _profileNameTextController = TextEditingController();
  bool profileNameEdit = false;

  void updateProfileName(String? profileName) async {
    setState(() {
      _profileNameTextController.text = profileName!;
      profileNameEdit = true;
      print("profileNameEdit is :" + profileNameEdit.toString());
    });
  }

  Future<void> saveProfileName(String? profileName) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection("users");

// Assume userId is the specific user ID you want to update
    String userId = user.uid;

// Assume newUserName is the new user name you want to set
    String newUserName = profileName!;

    try {
      // Update the 'userName' field in the specific document
      await usersCollection.doc(userId).update({'userName': newUserName});

      setState(() {
        imageCaption = profileName;
      });

      String msg = "Profile name successfully updated";
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
              msg.toString(),
              style: TextStyle(color: Color(0xFF207D4A), fontSize: 20),
            ));
          });
    } catch (error) {
      String msg = "Profile name not updated";
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
              msg.toString(),
              style: TextStyle(color: Color(0xFF207D4A), fontSize: 20),
            ));
          });
    } finally {
      setState(() {
        profileNameEdit = false;
      });
    }
  }

  final _oldPasswordEditingController = TextEditingController();
  final _newPasswordEditingController = TextEditingController();
  final _confirmNewPasswordEditingController = TextEditingController();

  Future<void> changePassword(String? newPassword, String? oldPassword,
      String? confirmNewPassword) async {
    bool correctOldPassword = false;
    if (newPassword == confirmNewPassword) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email.toString(),
          password: oldPassword.toString(),
        );
        correctOldPassword = true;
      } catch (error) {}

      if (correctOldPassword) {
        try {
          if (newPassword != null) {
            user.updatePassword(newPassword);
            final CollectionReference usersCollection =
            FirebaseFirestore.instance.collection("users");
            await usersCollection.doc(user.uid).update({'password': newPassword});
            String msg = "Password changed.";
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
          setState(() {
            _oldPasswordEditingController.text = "";
            _newPasswordEditingController.text = "";
            _confirmNewPasswordEditingController.text = "";
          });
        } catch (e) {
          String msg = "Password not changed";
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    content: Text(
                      msg.toString(),
                      style: TextStyle(color: Color(0xFF207D4A), fontSize: 20),
                    ));
              });
        } finally {}
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Old Password is wroung."),
            backgroundColor: Colors.red,
          ),
        );
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New password not match."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        // Adjust the decoration based on your design
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
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 5.0,
                      bottom: 16.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Your SettingsPage content goes here
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF207D4A),
                            ),
                          ),
                          // Add more widgets for your SettingsPage content
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              isLoadingCaption
                                  ? CircularProgressIndicator(
                                      color: Color(0xFF207D4A),
                                    )
                                  : profileNameEdit
                                      ? Container(
                                          width: 200,
                                          height: 55,
                                          // Adjust the width based on your design
                                          child: TextField(
                                            controller:
                                                _profileNameTextController,
                                            style: TextStyle(
                                                color: Color(0xFF207D4A),
                                                fontSize:
                                                    15 // Set the text color
                                                ),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFFD7E5DC),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              fillColor: Color(0xFFD7E5DC),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          "${imageCaption != null ? imageCaption : ""}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Color(0xFFC7DED2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit_note_outlined,
                                    color: Color(0xFF207D4A),
                                    size: 15,
                                  ),
                                  onPressed: () {
                                    updateProfileName(imageCaption != null
                                        ? imageCaption
                                        : "");
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              profileNameEdit
                                  ? Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFC7DED2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.save,
                                          color: Color(0xFF207D4A),
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          saveProfileName(
                                              _profileNameTextController.text);
                                        },
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFF207D4A),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: screenWidth * 0.8,
                              child: MyTextField(
                                  controller: _oldPasswordEditingController,
                                  hintText: "Old Password",
                                  obscureText: true,
                                  icon: Icon(Icons.password))),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: screenWidth * 0.8,
                              child: MyTextField(
                                  controller: _newPasswordEditingController,
                                  hintText: "New Password",
                                  obscureText: true,
                                  icon: Icon(Icons.password))),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: screenWidth * 0.8,
                              child: MyTextField(
                                  controller:
                                      _confirmNewPasswordEditingController,
                                  hintText: "Confirm New Password",
                                  obscureText: true,
                                  icon: Icon(Icons.password))),
                          SizedBox(
                            height: 15,
                          ),
                          MyButton(
                              onTap: () {
                                changePassword(
                                    _confirmNewPasswordEditingController.text,
                                    _oldPasswordEditingController.text,
                                    _confirmNewPasswordEditingController.text);
                              },
                              text: "Change Password")
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
