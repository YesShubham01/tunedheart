import 'package:flutter/material.dart';
import 'package:tunedheart/Pages/MusicPlayer/music_player.dart';
import 'package:tunedheart/Services/FireStore%20Service/firestore.dart';
import '../../Widget/custom_border.dart';
import '../../Widget/custom_button.dart';
import 'homePage.dart';

class CreateTeamPage extends StatefulWidget {
  final String roomCode;

  const CreateTeamPage({required this.roomCode, Key? key}) : super(key: key);

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  late List<dynamic> teamMembers;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: FireStore.readRoomMembers(widget.roomCode),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            teamMembers = snapshot.data!;
            return Scaffold(
              backgroundColor: const Color(0xFF141414),
              appBar: AppBar(
                title: const Text(
                  'Create Team',
                  style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TeamSection(
                        title: 'Room Code:', // Replace this with your room code
                        headingColor: Colors.red, // Change the heading color
                        lineColor: Colors.red,
                        content: Text(
                          widget.roomCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TeamSection(
                        title: 'Team Members:',
                        headingColor: Colors.red, // Change the heading color
                        lineColor: Colors.red,
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: teamMembers
                              .map(
                                (member) => Text(
                                  member,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: ' Start ',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      roomCode: widget.roomCode,
                                    )),
                          );
                        },
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.red,
              body: Center(child: Text("No data found.")),
            );
          }
        } else {
          return const Scaffold(
            backgroundColor: Colors.red,
            body: Center(child: Text("No data found.")),
          );
        }
      },
    );
  }
}
