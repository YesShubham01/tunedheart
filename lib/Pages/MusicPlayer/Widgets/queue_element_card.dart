import 'package:flutter/material.dart';

class QueueCard extends StatefulWidget {
  const QueueCard({super.key});

  @override
  State<QueueCard> createState() => _QueueCardState();
}

class _QueueCardState extends State<QueueCard> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          setState(() {
            isActive = !isActive;
          });
        },
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: isActive ? 120 : 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 7, 94, 164),
                    Color.fromARGB(255, 105, 178, 238)
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the child widget vertically
                  children: [
                    Text(
                      "Username",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      "Song Name",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            _getButtonsIfActive(),
          ],
        ),
      ),
    );
  }

  Widget _getButtonsIfActive() {
    if (isActive) {
      return Flexible(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
