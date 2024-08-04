import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sound_of_meme/pages/nav_bar_tabs/home_page.dart';
import 'package:sound_of_meme/pages/nav_bar_tabs/my_creations_page.dart';
import 'package:sound_of_meme/pages/nav_bar_tabs/profile_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [
    const HomePage(),
    const MyCreationsPage(),
    const ProfilePage(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.green,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: "My Creations",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
