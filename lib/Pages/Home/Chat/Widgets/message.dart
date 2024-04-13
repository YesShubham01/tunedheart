import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final String msg;
  final String timestamp;
  const MessageContainer(
      {super.key, required this.msg, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue, // Change color as needed
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              msg,
              style: const TextStyle(
                color: Colors.white, // Change text color as needed
                fontSize: 16.0, // Change font size as needed
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              timestamp,
              style: const TextStyle(
                  color: Color.fromARGB(
                      255, 210, 210, 210), // Change timestamp color as needed
                  fontSize: 12.0, // Change timestamp font size as needed
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
