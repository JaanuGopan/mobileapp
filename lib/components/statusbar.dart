import 'package:flutter/material.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.08,
            width: MediaQuery.of(context).size.width*0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: const Row(
              children: [
                Image(
                  image: AssetImage("lib/assets/profile2.png"),
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 20,
                ),
                Image(
                  image: AssetImage("lib/assets/profile3.png"),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 15,
                ),
                Image(
                  image: AssetImage("lib/assets/profile4.png"),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 15,
                ),
                Image(
                  image: AssetImage("lib/assets/profile5.png"),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 15,
                ),
                Image(
                  image: AssetImage("lib/assets/profile6.png"),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 15,
                ),
                Image(
                  image: AssetImage("lib/assets/profile3.png"),
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
