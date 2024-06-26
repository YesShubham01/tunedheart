import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunedheart/Pages/Profile/profile_page.dart';
import 'package:tunedheart/Services/FireAuth%20Service/authentication.dart';
import 'package:tunedheart/Widget/sqaure_button.dart';
import '../../Widget/custom_button.dart';
import 'create_team.dart';
import 'join_team.dart';
import 'dart:math';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  Future<void> createRoom() async {
    final CollectionReference rooms =
        FirebaseFirestore.instance.collection('rooms');
    final random = Random();

    // Generate a random 4-digit number between 1000 and 9999 (inclusive)
    int uniqueCode = 1000 + random.nextInt(9000);
    print(uniqueCode);

    String userName = Authenticate.getUserName();

    try {
      // Check if the generated code already exists in Firestore
      var snapshot = await rooms.doc(uniqueCode.toString()).get();
      if (!snapshot.exists) {
        // Add Firestore data
        await rooms.doc(uniqueCode.toString()).set({
          'roomCode': uniqueCode.toString(),
          'hostUser': userName, // Replace with the actual host user ID
          'members': [
            "$userName (Host)",
          ], // Replace with the actual list of member user IDs
          'currentSong':
              'Songs/Dandelions.mp3', // Replace with the actual current song ID
          'playbackState':
              true, // Replace with the actual playback state (true for playing, false for paused)
          'currentPosition': 0, // Replace with the actual current position
          // Add other room details as needed
        });

        // Navigate to the created room's page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CreateTeamPage(roomCode: uniqueCode.toString())),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Exponential backoff: wait for 2^retryAttempts seconds before retrying
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = Authenticate.getUserName();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      foregroundImage:
                          NetworkImage(Authenticate.getProfileUrl()),
                      // backgroundImage: NetworkImage(Authenticate.getProfileUrl()),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 200,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SqaureButton(
                      text: "Create Heart",
                      onPressed: () {
                        createRoom();
                      },
                      icon: const Image(
                          image: AssetImage("images/create_heart_icon.png")),
                      color: Colors.red),
                  const SizedBox(width: 30),
                  SqaureButton(
                      text: "Join Heart",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JoinTeamPage()),
                        );
                      },
                      icon: const Image(
                          image: AssetImage("images/join_heart_icon.png")),
                      color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
