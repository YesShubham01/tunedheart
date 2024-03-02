import 'package:flutter/material.dart';
import '../Widget/custom_button.dart';
import 'current_team.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinTeamPage extends StatefulWidget {
  const JoinTeamPage({Key? key}) : super(key: key);

  @override
  _JoinTeamPageState createState() => _JoinTeamPageState();
}

class _JoinTeamPageState extends State<JoinTeamPage> {
  final TextEditingController _roomCodeController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _roomCodeController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isButtonEnabled = _roomCodeController.text.isNotEmpty;
    });
  }

  void _joinRoom() async {
    final String roomCode = _roomCodeController.text.trim();
    final CollectionReference rooms =
        FirebaseFirestore.instance.collection('rooms');

    var roomSnapshot = await rooms.doc(roomCode).get();

    if (roomSnapshot.exists) {
      // Room exists, add the current user to the room's members
      await rooms.doc(roomCode).update({
        'members': FieldValue.arrayUnion(
            ['Pranjal']), // Replace with the actual user ID
      });

      // Navigate to the CurrentTeamPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CurrentTeamPage(roomCode: roomCode),
        ),
      );
    } else {
      // Room does not exist
      // Handle the scenario when the room does not exist (e.g., show an error message)
      // You can display a Snackbar or show an AlertDialog to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Room does not exist!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Join Team',
          style: TextStyle(
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _roomCodeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Enter Room Code',
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Enter valid room code',
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.blue,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Join',
              onPressed: _joinRoom,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
