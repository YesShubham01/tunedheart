import "package:flutter/material.dart";
import "package:tunedheart/Pages/MusicPlayer/Widgets/queue_element_card.dart";

class QueueSection extends StatelessWidget {
  const QueueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Text(
                  "Queue",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Add Song"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    20), // Adjust the value as needed for the desired roundness
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.grey],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _getText_Upnext(),
                    const QueueCard(),
                    const SizedBox(height: 8),
                    const QueueCard(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getText_Upnext() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Text(
          "Upnext",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
