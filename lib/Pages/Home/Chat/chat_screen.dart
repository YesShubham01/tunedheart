import 'package:flutter/material.dart';
import 'package:tunedheart/Pages/Home/Chat/Widgets/message.dart';
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
    return Flexible(
      flex: 8,
      fit: FlexFit.loose,
      child: SizedBox(
        width: width * 0.8,
        height: height * 0.7,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            MessageContainer(
              msg: "hello",
              timestamp: "10:10",
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
