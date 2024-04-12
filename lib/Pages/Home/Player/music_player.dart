import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tunedheart/Pages/MusicPlayer/Widgets/queue_section.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: Stack(
          children: [
            _backgroundBubbleLottieAnimation(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                _getMusicPlayerThumbnail(),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _getTitle(),
                  ),
                ),
                // _getSeekBar(),
                _getPlayerButtons(),
                const Expanded(child: QueueSection()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _backgroundBubbleLottieAnimation() {
    return Opacity(
      opacity: 0.5,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Lottie.asset(
          'assets/background_bubble.json',
          width: 300,
          height: 300,
          fit: BoxFit.contain,
          repeat: isPlaying,
          reverse: true,
        ),
      ),
    );
  }

  // _getSeekBar() {
  //   return StreamBuilder<Duration>(
  //     stream: audioPlayer.positionStream,
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return const SizedBox();
  //       }
  //       final String formattedDuration = formatDuration(
  //           snapshot.data ?? Duration.zero,
  //           audioPlayer.duration ?? Duration.zero);
  //       return Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Expanded(
  //                 child: Slider(
  //                   value: snapshot.data!.inMilliseconds.toDouble(),
  //                   onChanged: (double value) {
  //                     Duration newPosition =
  //                         Duration(milliseconds: value.toInt());
  //                     // seekAudio(roomId, newPosition);
  //                     audioPlayer.seek(newPosition);
  //                     isSeeking = true;
  //                   },
  //                   onChangeEnd: (double value) async {
  //                     Duration newPosition =
  //                         Duration(milliseconds: value.toInt());
  //                     seekAudio(roomId, newPosition);
  //                   },
  //                   min: 0.0,
  //                   max: audioPlayer.duration?.inMilliseconds.toDouble() ?? 0.0,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(right: 15),
  //             child: Align(
  //               alignment: Alignment.bottomRight,
  //               child: Text(
  //                 formattedDuration,
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  _getPlayerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // Shuffle button onPressed functionality
          },
          icon: const Icon(
            Icons.shuffle,
            color: Colors.white, // Change color to white
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            // Previous button onPressed functionality
          },
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white, // Change color to white
            size: 30,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: IconButton(
            onPressed: () {
              // Play/pause button onPressed functionality
              setState(() {
                isPlaying = !isPlaying;
              });
              // if (isPlaying) {
              //   playAudioFromFirestore(roomId);
              // } else {
              //   pauseAudio(roomId);
              // }
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // Next button onPressed functionality
          },
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white, // Change color to white
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            // Like button onPressed functionality
            setState(() {
              isLiked = !isLiked;
            });
          },
          icon: Icon(
            Icons.favorite,
            color: isLiked ? Colors.red : Colors.grey,
            size: 30,
          ),
        ),
      ],
    );
  }

  _getTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Music Title",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "Host: Name",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  _getMusicPlayerThumbnail() {
    return Container(
      width: 300, // Adjust width as needed
      height: 300, // Adjust height as needed
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 1), // Adjust color as needed
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
      ),
      child: Center(
        child: Lottie.asset(
          'assets/music_animation.json',
          width: 500,
          height: 500,
          fit: BoxFit.contain,
          repeat: isPlaying,
        ),
      ),
    );
  }
}
