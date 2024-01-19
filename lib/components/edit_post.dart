import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartgarden/components/button.dart';
import 'package:smartgarden/components/text_field.dart';

class EditPostOverlay extends StatefulWidget {
  final userId;
  final postindex;

  const EditPostOverlay(
      {Key? key, required this.userId, required this.postindex})
      : super(key: key);

  @override
  _EditPostOverlayState createState() => _EditPostOverlayState();
}

class _EditPostOverlayState extends State<EditPostOverlay> {
  TextEditingController _postTextController = TextEditingController();
  String? imageUrl;
  bool isLoading = false;

  Future<String?> getPostDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Assuming userData['posts'] is not null and is an array
        if (userData.containsKey('posts') &&
            userData['posts'].length > widget.postindex) {
          // Get the post at the specified index
          Map<String, dynamic> post = userData['posts'][widget.postindex];

          // Check if the post has 'imageUrl' field
          if (post.containsKey('imageUrl')) {
            setState(() {
              _postTextController.text = post['caption'];
              imageUrl = post['imageUrl'];
            });
            // Return the imageUrl
            return post['imageUrl'];
          }
        }
      }
    } catch (error) {
      print("Error fetching imageUrl: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    // Return null if something went wrong
    return null;
  }

  bool isLoadingupload = false;
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

  @override
  void initState() {
    // TODO: implement initState
    getPostDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Color(0xFF207D4A),
              ),
            ),
          )
        : Container(
            child: SingleChildScrollView(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                content: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Edit Post",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF207D4A),
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Color(0xFFC7DED2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete_outline_outlined,
                                  color: Color(0xFF207D4A),
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFC7DED2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageUrl!.isEmpty
                                  ? Image(
                                      image: AssetImage("lib/assets/post2.png"),
                                      width: 200,
                                      height: 200,
                                    )
                                  : selectedImageFile != null
                                      ? Image.file(
                                          File(selectedImageFile!.path),
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          imageUrl!,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFFC7DED2),
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              icon: Icon(
                                Icons.image_outlined,
                                color: Color(0xFF207D4A),
                                size: 25,
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFFC7DED2),
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Color(0xFF207D4A),
                                size: 25,
                              ),
                              onPressed: () {
                                selectCameraOrGallery(true);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: _postTextController,
                        hintText: "Insert Caption",
                        obscureText: false,
                        icon: Icon(Icons.comment),
                        width: 300,
                        height: 70,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Spacer(),
                      MyButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "Save")
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
