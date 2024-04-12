import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunedheart/Pages/Home/Chat/chat_screen.dart';
import 'package:tunedheart/Pages/Home/Header/members_in_room.dart';
import 'package:tunedheart/Pages/Home/Player/music_player.dart';
import 'package:tunedheart/Pages/MusicPlayer/music_player.dart';
import 'package:tunedheart/Providers/music_provider.dart';

class MainPage extends StatefulWidget {
  String roomCode;
  MainPage({super.key, required this.roomCode});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    context.read<MusicProvider>().setActiveRoomCode(widget.roomCode);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roomNameTitle(),
                const MembersPresent(),
                const ChatScreen(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const MusicPlayerScreen();
                        },
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1), // start position
                              end: Offset.zero, // end position
                            ).animate(animation),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(
                            milliseconds: 400), // adjust the duration as needed
                      ),
                    );
                  },
                  child: _buildMusicPlayerBottom(height, width),
                )
              ],
            ),
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

  _buildMusicPlayerBottom(double h, double w) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.pink,
        // borderRadius: BorderRadius.circular(20.0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      height: h * 0.1,
      // width: w * 0.8,
    );
  }
}
