import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tunedheart/Objects/audio_detail.dart';
import 'package:tunedheart/Pages/MusicPlayer/playback_state.dart';
import 'package:tunedheart/Pages/MusicPlayer/Widgets/queue_section.dart';
import 'package:tunedheart/Providers/music_provider.dart';

class MusicPlayer extends StatefulWidget {
  final String roomCode;
  final String filename;
  const MusicPlayer({Key? key, required this.roomCode,required this.filename}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late String roomId = widget.roomCode;
  bool isSeeking = false;
    late String filename;
      late String hostUser;

  @override
  void initState() {
    super.initState();
    initializeAudioPlayer();
    filename = widget.filename;
    fetchHostUser(); 
  }



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
                _getSeekBar(),
                _getPlayerButtons(),
                const Expanded(child: QueueSection()),
              ],
            ),
          ],
        ),
      ),
    );
  }


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

  String formatDuration(Duration currentDuration, Duration totalDuration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(currentDuration.inMinutes.remainder(60));
    String seconds = twoDigits(currentDuration.inSeconds.remainder(60));
    return "$minutes:$seconds / ${twoDigits(totalDuration.inMinutes.remainder(60))}:${twoDigits(totalDuration.inSeconds.remainder(60))}";
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

  _getSeekBar() {
    return StreamBuilder<Duration>(
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
                      isSeeking = true;
                    },
                    onChangeEnd: (double value) async {
                      Duration newPosition =
                          Duration(milliseconds: value.toInt());
                      seekAudio(roomId, newPosition);
                    },
                    min: 0.0,
                    max: audioPlayer.duration?.inMilliseconds.toDouble() ?? 0.0,
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
    );
  }

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
    );
  }

  _getTitle() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
        filename,
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        
        Text(
          "Host: $hostUser",
          style: const TextStyle(color: Colors.white),
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
