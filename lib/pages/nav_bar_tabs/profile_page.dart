import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/pages/others/liked_song_page.dart';
import 'package:sound_of_meme/pages/others/purchased_song_page.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';
import 'package:sound_of_meme/widgets/need_login_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String email = "";
  late String name = "";
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    var data = await Provider.of<MemeSongProvider>(context, listen: false)
        .getUserDetails();
    setState(() {
      email = data["email"];
      name = data["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: Consumer<MemeSongProvider>(builder: (context, value, child) {
        if (value.accessToken.isEmpty) {
          return const NeedLoginButton();
        } else {
          return ListView(
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade900,
                  radius: 80,
                  child: const Icon(
                    Icons.person_2,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(
                  Icons.money,
                ),
                title: const Text("Purchased songs"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchasedSongPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.heart_solid,
                ),
                title: const Text("Liked songs"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LikedSongPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text("Logout"),
                onTap: () {
                  value.logout();
                },
              ),
            ],
          );
        }
      }),
    );
  }
}
