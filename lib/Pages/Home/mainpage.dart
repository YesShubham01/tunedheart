import 'package:flutter/material.dart';
import 'package:tunedheart/Pages/Home/Chat/chat_screen.dart';
import 'package:tunedheart/Pages/Home/Header/members_in_room.dart';

class MainPage extends StatefulWidget {
  String roomCode;
  MainPage({super.key, required this.roomCode});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roomNameTitle(),
              const MembersPresent(),
              const ChatScreen(),
            ],
          ),
        ),
      ),
    );
  }

  _roomNameTitle() {
    return const Text(
      "My Heart",
      style: TextStyle(fontSize: 24, color: Colors.white),
    );
  }
}
