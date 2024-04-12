import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunedheart/Providers/music_provider.dart';
import 'package:tunedheart/Services/FireStore%20Service/firestore.dart';

class MembersPresent extends StatefulWidget {
  const MembersPresent({super.key});

  @override
  State<MembersPresent> createState() => _MembersPresentState();
}

class _MembersPresentState extends State<MembersPresent> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: width * 0.1),
      child: Row(
        children: [
          const Text(
            "Members",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          FutureBuilder<List<dynamic>>(
            future: FireStore.readRoomMembers(
                context.read<MusicProvider>().activeRoomCode!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If the Future is still running, show a loading indicator
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If there is an error, display an error message
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                // If there is no data or the data is empty, display a message
                return const Text('No members available.');
              } else {
                // If the data is available, you can use it in your UI
                List<dynamic> members = snapshot.data as List<dynamic>;
                return Row(
                  children: members
                      .map((member) => _buildMemberAvatar(0, member))
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(int index, String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: CircleAvatar(
        backgroundColor: Colors.red,
        child: Text(
          name[0],
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
