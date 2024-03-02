import 'package:flutter/material.dart';
import '../Widget/custom_border.dart';
import '../Widget/custom_button.dart';
import 'homePage.dart';

class CreateTeamPage extends StatelessWidget {
  final List<String> teamMembers = [
    'John Doe',
    'Jane Smith',
    'Alice Johnson',
    'Bob Williams'
  ];

  final String roomCode;

  CreateTeamPage({required this.roomCode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  roomCode,
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
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
