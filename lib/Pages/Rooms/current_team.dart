import 'package:flutter/material.dart';
import 'package:tunedheart/Services/FireStore%20Service/firestore.dart';
import '../../Widget/custom_border.dart';

class CurrentTeamPage extends StatefulWidget {
  final String roomCode;

  const CurrentTeamPage({required this.roomCode, Key? key}) : super(key: key);
  @override
  State<CurrentTeamPage> createState() => _CurrentTeamPageState();
}

class _CurrentTeamPageState extends State<CurrentTeamPage> {
  // Replace this with the actual room code
  late List<dynamic> teamMembers;

  // Replace this with actual team members
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
                  backgroundColor: const Color(0xFF141414),
                  title: const Text(
                    'Current Team',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TeamSection(
                          title:
                              'Room Code:', // Replace this with your room code
                          headingColor: const Color.fromARGB(
                              255, 71, 160, 233), // Change the heading color
                          content: Text(
                            widget.roomCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          lineColor: Colors.blue,
                        ),
                        const SizedBox(height: 20),
                        TeamSection(
                          title: 'Team Members:',
                          lineColor: Colors.blue,
                          headingColor: const Color.fromARGB(
                              255, 71, 160, 233), // Change the heading color
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
                        const Text(
                          'Waiting for host to start...',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ));
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
