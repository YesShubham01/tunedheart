import 'package:flutter/material.dart';
import 'package:tunedheart/Pages/Home/Player/music_player.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // Check if the user swiped upwards
        if (details.primaryVelocity! < 0) {
          // Navigate to the second page
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
        }
      },
      child: Flexible(
        flex: 8,
        fit: FlexFit.loose,
        child: Container(
          width: width * 0.8,
          height: height * 0.7,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("chat screen")],
          ),
        ),
      ),
    );
  }
}
