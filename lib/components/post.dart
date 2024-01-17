import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Image(
                  image: AssetImage("lib/assets/profile2.png"),
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Profile Name",
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
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Image(
                  image: AssetImage("lib/assets/post1.png"),
                  width: 300,
                  height: 300,
                ),
                SizedBox(
                  width: 10,
                ),
              ],
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
