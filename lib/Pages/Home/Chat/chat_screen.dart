import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunedheart/Pages/Home/Chat/Widgets/message.dart';
import 'package:tunedheart/Pages/Home/Player/music_player.dart';
import 'package:tunedheart/Providers/music_provider.dart';
import 'package:tunedheart/Services/FireStore%20Service/firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<dynamic> _messageData;
  @override
  void initState() {
    super.initState();
    _messageData = [];
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            FutureBuilder<List<dynamic>>(
                future: FireStore.getMessagesInRoom(
                    context.read<MusicProvider>().activeRoomCode!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      _messageData = snapshot.data!;
                      return Column(
                        children: _messageData.map((message) {
                          // Assuming message is a list with two elements: msg and timestamp
                          String msg = message;

                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: MessageContainer(
                              msg: msg,
                              timestamp: "5:10",
                            ),
                          );
                        }).toList(),
                      );
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(
                        color: Colors.white), // Set text color to white
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.white,
                      hoverColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    _sendMessage(context.read<MusicProvider>().activeRoomCode!);
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String room) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      FireStore.addMessageToRoom(room, message);
      setState(() {});
      _messageController.clear();
    }
  }
}
