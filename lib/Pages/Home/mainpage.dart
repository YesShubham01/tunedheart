import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunedheart/Objects/audio_detail.dart';
import 'package:tunedheart/Pages/Home/Chat/chat_screen.dart';
import 'package:tunedheart/Pages/Home/Header/members_in_room.dart';
import 'package:tunedheart/Pages/MusicPlayer/playback_state.dart';

class MainPage extends StatefulWidget {
  String roomCode;
  MainPage({super.key, required this.roomCode});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    final AudioPlayer audioPlayer = AudioPlayer();
      bool isPlaying = false;
  bool isLiked = false;
      late String hostUser;
      
    Future<void> fetchHostUser() async {
    try {
      DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .get();

      if (roomSnapshot.exists) {
        setState(() {
          hostUser = roomSnapshot['hostUser'];
        });
      }
    } catch (e) {
      print("Error fetching hostUser: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHostUser(); 
  }

    Future<void> playAudioFromFirestore(String roomId) async {
    AudioDetails audioDetails = await fetchAudioDetailsFromFirestore(roomId);
    final audioUrl = audioDetails.audioUrl;
    final currentPosition = audioDetails.currentPosition;
    final playbackState = audioDetails.playbackState;

    try {
      await audioPlayer.setUrl(audioUrl);
      await audioPlayer.seek(Duration(milliseconds: currentPosition));
      await audioPlayer.play();
      updatePlaybackState(roomId);
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pauseAudio(String roomId) async {
    try {
      await audioPlayer.pause();
      updatePlaybackState(roomId);
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  Future<void> updatePlaybackState(String roomId) async {
    final position = audioPlayer.position;
    final isPlaying = audioPlayer.playing;
    final playbackState =
        PlaybackState(position: position, isPlaying: isPlaying);

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .update(playbackState.toMap());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roomNameTitle(),
                const MembersPresent(),
                const ChatScreen(),
                _getPlayerButtons(),
                // _buildMusicPlayerBottom(height, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _roomNameTitle() {
    return const Text(
      "My Heart",
      style: TextStyle(fontSize: 24, color: Colors.white),
    );
  }

  // _buildMusicPlayerBottom(double h, double w) {
  //   return Container(
    
  //     // width: w * 0.8,
  //   );
  // }

  _getPlayerButtons() {
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     IconButton(
    //       onPressed: () {
    //         // Shuffle button onPressed functionality
    //       },
    //       icon: const Icon(
    //         Icons.shuffle,
    //         color: Colors.white, // Change color to white
    //         size: 30,
    //       ),
    //     ),
    //     IconButton(
    //       onPressed: () {
    //         // Previous button onPressed functionality
    //       },
    //       icon: const Icon(
    //         Icons.skip_previous,
    //         color: Colors.white, // Change color to white
    //         size: 30,
    //       ),
    //     ),
    //     Container(
    //       decoration: const BoxDecoration(
    //         shape: BoxShape.circle,
    //         color: Colors.blue,
    //       ),
    //       child: IconButton(
    //         onPressed: () {
    //           // Play/pause button onPressed functionality
    //           setState(() {
    //             isPlaying = !isPlaying;
    //           });
    //           if (isPlaying) {
    //             playAudioFromFirestore(widget.roomCode);
    //           } else {
    //             pauseAudio(widget.roomCode);
    //           }
    //         },
    //         icon: Icon(
    //           isPlaying ? Icons.pause : Icons.play_arrow,
    //           color: Colors.white,
    //           size: 40,
    //         ),
    //       ),
    //     ),
    //     IconButton(
    //       onPressed: () {
    //         // Next button onPressed functionality
    //       },
    //       icon: const Icon(
    //         Icons.skip_next,
    //         color: Colors.white, // Change color to white
    //         size: 30,
    //       ),
    //     ),
    //     IconButton(
    //       onPressed: () {
    //         // Like button onPressed functionality
    //         setState(() {
    //           isLiked = !isLiked;
    //         });
    //       },
    //       icon: Icon(
    //         Icons.favorite,
    //         color: isLiked ? Colors.grey : Colors.red,
    //         size: 30,
    //       ),
    //     ),
    //   ],
    // );
    return Container(
      decoration: const BoxDecoration(

        color: Colors.pink,
        // borderRadius: BorderRadius.circular(20.0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      height: 50.0,
      // width: w * 0.8,
      child:Row(
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
              if (isPlaying) {
                playAudioFromFirestore(widget.roomCode);
              } else {
                pauseAudio(widget.roomCode);
              }
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
            color: isLiked ? Colors.grey : Colors.red,
            size: 30,
          ),
        ),
      ],
    ),
    );
  }

  _getTitle() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
        'Hello',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        
        Text(
          "Host: $hostUser",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
