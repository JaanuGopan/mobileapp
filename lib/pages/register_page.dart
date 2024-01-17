import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../models/user.dart' as model;

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    super.dispose();
  }

  String? imageUrl;
  bool isLoading = false;
  XFile? selectedImageFile;

  void selectCameraOrGallery(bool cameraOrGallery) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(
      source: cameraOrGallery ? ImageSource.camera : ImageSource.gallery,
    );

    if (imageFile != null) {
      setState(() {
        selectedImageFile = imageFile;
      });
    }
  }

  Future<String?> uploadProfilePhoto(String? userId) async {
    if (selectedImageFile == null) {
      return null;
    }

    try {
      setState(() {
        isLoading = true; // Set loading to true when starting image upload
      });

      String uniqueFileName =
          'profile_${userId}.jpeg';

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('profile_images');
      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

      await referenceImageToUpload.putFile(File(selectedImageFile!.path));
      String uploadedImageUrl = await referenceImageToUpload.getDownloadURL();

      print("The image URL is: $uploadedImageUrl");

      return uploadedImageUrl.toString();
    } catch (error) {
      print("Error uploading image: $error");
      // You can add additional error handling if needed
      return null;
    } finally {

    }
  }



  Future<void> signup() async {
    if (passwordConfirmed()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim(),
          password: _passwordTextController.text.trim(),
        );

        // Add image and user details
        String? imgUrl = await uploadProfilePhoto(userCredential.user?.uid.toString());
        await addUserDetails(
          _nameTextController.text.trim(),
          _passwordTextController.text.trim(),
          _emailTextController.text.trim(),
          userCredential.user?.uid,
          imgUrl
        );
      } on FirebaseAuthException catch (e) {
        print("Firebase Authentication Error: $e");
      }
    } else {
      print("Password not matched...");
    }
  }

  Future<void> addUserDetails(
      String name, String password, String email, String? userId,String? imgUrl) async {
    try {
      model.User user = model.User(
        userId: userId!,
        userName: name,
        password: password,
        email: email,
        profilePicture: imgUrl!,
        posts: [],
        followers: [],
        followings: [],
      );

      await FirebaseFirestore.instance.collection('users').doc(userId).set(user.toJson());
      print('User details uploaded successfully!');
    } catch (e) {
      print('Error uploading user details: $e');
    }
  }



  bool passwordConfirmed() {
    return _passwordTextController.text.trim() ==
        _confirmPasswordTextController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/background3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Register",
                            style: TextStyle(
                              color: Color(0xFF207D4A),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Color(0xFFD7E5DC),
                                backgroundImage: selectedImageFile != null
                                    ? FileImage(File(selectedImageFile!.path))
                                    : null,
                              ),
                              Positioned(
                                bottom: -10,
                                left: 100,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo_outlined,
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
                                  color: Colors.white,
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
                          const SizedBox(height: 20),
                          Text(
                            "Let's create an account for you",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 25),
                          MyTextField(
                            controller: _nameTextController,
                            hintText: "Full Name",
                            obscureText: false,
                            icon: Icon(Icons.person),
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: _emailTextController,
                            hintText: "Email",
                            obscureText: false,
                            icon: Icon(Icons.mail),
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: _passwordTextController,
                            hintText: "Password",
                            obscureText: true,
                            icon: Icon(Icons.lock),
                          ),
                          SizedBox(height: 10),
                          MyTextField(
                            controller: _confirmPasswordTextController,
                            hintText: "Confirm Password",
                            obscureText: true,
                            icon: Icon(Icons.lock),
                          ),
                          SizedBox(height: 20),
                          MyButton(onTap: signup, text: "Register"),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  "Login now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF207D4A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
