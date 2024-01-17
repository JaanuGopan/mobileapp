import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smartgarden/auth/login_or_register.dart';
import 'package:smartgarden/pages/home_page.dart';
import 'package:smartgarden/pages/post_page.dart';
import 'package:smartgarden/pages/profile_page.dart';
import 'package:smartgarden/pages/setting_page.dart';

import 'favrout_page.dart'; // Import your other pages

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Add your other pages to this list
  List<Widget> pages = [
    HomePage(),
    FavoritePage(),
    CameraPage(),
    ProfilePage(),
    SettingsPage(),
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Smart Garden",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF207D4A),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFF207D4A),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout,
              color: Color(0xFF207D4A),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF207D4A),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Smart Garden',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.account_circle,color: Color(0xFF207D4A),size: 35,),
              title: Text('Profile',style: TextStyle(color: Color(0xFF207D4A),fontSize: 20),),
              onTap: () {
                // Handle drawer item 1
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings,color: Color(0xFF207D4A),size: 35,),
              title: Text('Settings',style: TextStyle(color: Color(0xFF207D4A),fontSize: 20),),
              onTap: () {
                // Handle drawer item 2
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout,color: Color(0xFF207D4A),size: 35,),
              title: Text('Logout',style: TextStyle(color: Color(0xFF207D4A),fontSize: 20)),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Add more list items as needed
          ],
        ),
      ),
      endDrawer: Drawer(
        // Add content for endDrawer
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF207D4A),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: pages[_currentIndex],
    );
  }
}
