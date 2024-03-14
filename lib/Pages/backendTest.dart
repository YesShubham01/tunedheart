import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lottie/lottie.dart';

class BackendTestingPage extends StatefulWidget {
  final String roomCode;
  const BackendTestingPage({Key? key, required this.roomCode})
      : super(key: key);

  @override
  _BackendTestingPageState createState() => _BackendTestingPageState();
}

class _BackendTestingPageState extends State<BackendTestingPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late String roomId = widget.roomCode;
  bool isSeeking=false;

  @override
  void initState() {
    super.initState();
    initializeAudioPlayer();
  }

  Future<void> initializeAudioPlayer() async {
    playAudioFromFirestore(roomId);
    listenForUpdates(roomId);
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

  Future<void> seekAudio(String roomId, Duration currentPosition) async {
    try {
      await audioPlayer.seek(currentPosition);
      updatePlaybackState(roomId);
    } catch (e) {
      print("Error seeking audio: $e");
    }
  }

  void updatePlayingStatus(String roomId, bool isPlaying) {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .update({'playbackState': isPlaying});
  }

  void updatePosition(String roomId, int currentPosition) {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .update({'currentPosition': currentPosition});
  }

  void listenForUpdates(String roomId) {
    try {
      CollectionReference rooms =
          FirebaseFirestore.instance.collection('rooms');
      rooms.doc(roomId).snapshots().listen((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            PlaybackState playbackState = PlaybackState.fromMap(data);
            handlePlaybackState(playbackState);
          }
        }
      });
    } catch (e) {
      print("Error listening for updates: $e");
    }
  }

  void handlePlaybackState(PlaybackState playbackState) {
    // Update UI or perform actions based on the received playback state
    // For example, update play/pause button, seek bar, etc.
    // You can access playbackState.position and playbackState.state

    // Update the local audio player accordingly
    audioPlayer.seek(playbackState.position);
    if (playbackState.isPlaying) {
      audioPlayer.play();
    } else {
      audioPlayer.pause();
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

  bool isPlaying = false;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Stack(
          children: [
            Opacity(
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 90,
                ),
                Container(
                  width: 300, // Adjust width as needed
                  height: 300, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        0, 0, 0, 1), // Adjust color as needed
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
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
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My English Mash-up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Username",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<Duration>(
                  stream: audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    final String formattedDuration = formatDuration(
                        snapshot.data ?? Duration.zero,
                        audioPlayer.duration ?? Duration.zero);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Slider(
                                value: snapshot.data!.inMilliseconds.toDouble(),
                                onChanged: (double value) {
                                  Duration newPosition =
                                      Duration(milliseconds: value.toInt());
                                  // seekAudio(roomId, newPosition);
                                  audioPlayer.seek(newPosition);
                                  isSeeking=true;
                                },
                                onChangeEnd: (double value) async {
                                Duration newPosition=Duration(milliseconds: value.toInt());
                                  seekAudio(roomId, newPosition);},
                                min: 0.0,
                                max: audioPlayer.duration?.inMilliseconds
                                        .toDouble() ??
                                    0.0,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              formattedDuration,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Row(
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
                            playAudioFromFirestore(roomId);
                          } else {
                            pauseAudio(roomId);
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration currentDuration, Duration totalDuration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(currentDuration.inMinutes.remainder(60));
    String seconds = twoDigits(currentDuration.inSeconds.remainder(60));
    return "$minutes:$seconds / ${twoDigits(totalDuration.inMinutes.remainder(60))}:${twoDigits(totalDuration.inSeconds.remainder(60))}";
  }
}

class PlaybackState {
  final Duration position;
  final bool isPlaying; // Change the type to bool

  PlaybackState({required this.position, required this.isPlaying});

  Map<String, dynamic> toMap() {
    return {
      'currentPosition': position.inMilliseconds,
      'playbackState': isPlaying
    };
  }

  factory PlaybackState.fromMap(Map<String, dynamic> map) {
    return PlaybackState(
      position: Duration(milliseconds: map['currentPosition']),
      isPlaying:
          map['playbackState'] ?? false, // Default to false if not present
    );
  }
}

class AudioDetails {
  final String audioUrl;
  final int currentPosition;
  final bool playbackState;

  AudioDetails(
      {this.audioUrl = '',
      this.currentPosition = 0,
      this.playbackState = false});
}

Future<AudioDetails> fetchAudioDetailsFromFirestore(String roomId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> roomData =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();

    if (!roomData.exists) {
      print('Error: Room document does not exist for room ID $roomId');
      return AudioDetails(); // Return a default object or handle the error accordingly
    }

    String audioPath = roomData['currentSong'] ?? '';
    int currentPosition = roomData['currentPosition'] ?? 0;

    // Handle the boolean value appropriately
    bool playbackState = roomData['playbackState'] as bool? ?? false;

// String audioUrl="gs://duostreaming-a7e93.appspot.com/Song/Love-Me-Like-You-Do_320(PaglaSongs).mp3";
    // Construct the full URL from the path
    // String audioUrl =
    //     await firebase_storage.FirebaseStorage.instance.ref(audioPath).getDownloadURL();

    Future<String> getFirebaseDownloadUrl(String path) async {
      try {
        final firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref(path);
        final String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        print('Error getting Firebase download URL: $e');
        return ''; // Handle the error accordingly
      }
    }

    String audioUrl = await getFirebaseDownloadUrl(audioPath);

    print('Fetched audio URL: $audioUrl');
    return AudioDetails(
      audioUrl: audioUrl,
      currentPosition: currentPosition,
      playbackState: playbackState,
    );
  } catch (e) {
    print("Error fetching audio details: $e");
    return AudioDetails(); // Return a default object or handle the error accordingly
  }
}
