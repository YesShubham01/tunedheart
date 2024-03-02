import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class BackendTestingPage extends StatefulWidget {
  const BackendTestingPage({Key? key}) : super(key: key);

  @override
  _BackendTestingPageState createState() => _BackendTestingPageState();
}

class _BackendTestingPageState extends State<BackendTestingPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late String roomId;

  @override
  void initState() {
    super.initState();
    initializeAudioPlayer();
  }

  Future<void> initializeAudioPlayer() async {
    roomId = "2557"; // Replace with your logic to fetch the room code
    playAudioFromFirestore(roomId);
    listenForUpdates(roomId);
  }




// Future<AudioDetails> fetchAudioDetailsFromFirestore(String roomId) async {
//   try {
//     DocumentSnapshot<Map<String, dynamic>> roomData =
//         await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();

//     if (!roomData.exists) {
//       print('Error: Room document does not exist for room ID $roomId');
//       return AudioDetails(); // Return a default object or handle the error accordingly
//     }

//     // Get the audio ID from the 'rooms' collection
//     String audioId = roomData['currentSong'] ?? '';

//     // Fetch audio details from the 'Songs' collection using the audio ID
//     DocumentSnapshot<Map<String, dynamic>> audioData =
//         await FirebaseFirestore.instance.collection('Songs').doc(audioId).get();

//     if (!audioData.exists) {
//       print('Error: Audio document does not exist for audio ID $audioId');
//       return AudioDetails(); // Return a default object or handle the error accordingly
//     }

//     // Get the audio URL stored in Firestore
//     String audioPath = audioData['audioUrl'] ?? '';
//     int currentPosition = roomData['currentPosition'] ?? 0;
//     bool playbackState = roomData['playbackState'] as bool? ?? false;

  

//     String audioUrl = await firebase_storage.FirebaseStorage.instance
//     .ref().child(audioPath).getDownloadURL();


//     print('Fetched audio URL: $audioUrl');
//     return AudioDetails(
//       audioUrl: audioUrl,
//       currentPosition: currentPosition,
//       playbackState: playbackState,
//     );
//   } catch (e) {
//     print("Error fetching audio details: $e");
//     return AudioDetails(); // Return a default object or handle the error accordingly
//   }
// }




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
    FirebaseFirestore.instance.collection('rooms').doc(roomId).update({'playbackState': isPlaying});
  }

  void updatePosition(String roomId, int currentPosition) {
    FirebaseFirestore.instance.collection('rooms').doc(roomId).update({'currentPosition': currentPosition});
  }
 void listenForUpdates(String roomId) {
    try {
      CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
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
  final playbackState = PlaybackState(position: position, isPlaying: isPlaying);

  await FirebaseFirestore.instance
      .collection('rooms')
      .doc(roomId)
      .update(playbackState.toMap());
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => playAudioFromFirestore(roomId),
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () => pauseAudio(roomId),
              child: const Text('Pause'),
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Slider(
                      value: snapshot.data!.inMilliseconds.toDouble(),
                      onChanged: (double value) {
                        Duration newPosition =
                            Duration(milliseconds: value.toInt());
                        seekAudio(roomId, newPosition);
                      },
                      min: 0.0,
                      max: audioPlayer.duration?.inMilliseconds.toDouble() ??
                          0.0,
                    ),
                    Text(formattedDuration),
                  ],
                );
              },
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
    return {'currentPosition': position.inMilliseconds, 'playbackState': isPlaying};
  }

  factory PlaybackState.fromMap(Map<String, dynamic> map) {
    return PlaybackState(
      position: Duration(milliseconds: map['currentPosition']),
      isPlaying: map['playbackState'] ?? false, // Default to false if not present
    );
  }
}


class AudioDetails {
  final String audioUrl;
  final int currentPosition;
  final bool playbackState;

  AudioDetails({this.audioUrl = '', this.currentPosition = 0, this.playbackState = false});
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