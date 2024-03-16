import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tunedheart/Objects/audio_detail.dart';

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

    String audioUrl = audioPath;

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
