import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunedheart/Objects/audio_detail.dart';
import 'package:tunedheart/Pages/MusicPlayer/music_player.dart';
import 'package:tunedheart/Pages/MusicPlayer/playback_state.dart';
import 'package:tunedheart/Services/FireStore%20Service/firestore.dart';
import 'current_team.dart';

class HomePage extends StatefulWidget {
  final String roomCode;
  const HomePage({Key? key,required this.roomCode}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


// String roomId=widget.roomCode;
  int _currentIndex = 0;
  late List<bool> _isPlayingList;
  String? currentSongUrl;
  bool isPlaying=false;



  String extractFilenameFromUrl(String url) {
  String path = Uri.parse(url).pathSegments.last;
  // Remove the file extension
List<String> parts=path.split('/');
String filename=parts.last;
  // Remove file extension
  filename = filename.replaceAll('.mp3', '');
  // Replace %20 with spaces
  filename = filename.replaceAll('%20', ' ');
  return filename;
}



  void updateCurrentSong(String url) {
    setState(() {
      currentSongUrl = url;
    });
  }




  @override
  void initState() {
    super.initState();
  
  
    // _initializeIsPlayingList(); // Initialize _isPlayingList in initState
  }
final AudioPlayer audioPlayer = AudioPlayer();
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

  // void _initializeIsPlayingList() {
  //   _isPlayingList = List.generate(songs.length, (_) => false);
  // }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('TunedHeartz'),
        titleTextStyle: const TextStyle(
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xFF141414),
      ),
      body:  StreamBuilder(
                  stream: FireStore.userUploadsStream(),
                  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(
  value: 0.5, // Set the current progress value between 0.0 and 1.0
  backgroundColor: Colors.grey, // Optionally, you can set a background color
  valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set the color of the progress indicator
  strokeWidth: 4, // Set the thickness of the progress indicator
),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }
    else if (snapshot.data == null) {
      // Handle the case where snapshot data is null
      return const Text('No data available');
    } else {
      List<dynamic> uploads = snapshot.data!;
      return  Stack(
            children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: uploads.length,
        itemBuilder: (context, index) {
          var upload = uploads[index];
          String filename = extractFilenameFromUrl(upload.toString());
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16.0, 15.0, 8.0, 0.0),
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('imageUrl'),
            ),
            title: Text(filename, style: const TextStyle(fontSize: 14, color: Colors.white)),
            onTap: () {
    // Store the link in the backend Firestore collection under rooms with the current song field name
    FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode).update({
      'currentSong': upload.toString(),
    }).then((value) {
      // // Navigate to the music player page and pass the room code as a parameter
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => MusicPlayer(roomCode: widget.roomCode,filename: filename,)),
      // );
      updateCurrentSong(upload.toString());
        // Toggle playback (optional, implement your logic here)togglePlayback();
    }).catchError((error) {
      print("Failed to update current song: $error");
      // Handle error if needed
    });
  },
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Handle song options (play, edit, delete)
              },
            ),
          );
        },
      ),
//         Positioned(
//                 bottom: 0.0, // Positioned at the bottom
//                 left: 0.0, // Left aligned
//                 right: 0.0, // Right aligned
//                 height: 72.0, // Fixed height
//                 child: Container(
//                   color: Colors.black.withOpacity(0.8), // Semi-transparent background
//                   child: currentSongUrl != null
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Song title and artist (replace with actual data retrieval)
//                             Text(
//                               "Currently Playing: ${extractFilenameFromUrl(currentSongUrl!)}",
//                               style: const TextStyle(color: Colors.white, fontSize: 16.0),
//                             ),
//                             // Play/pause button
//                             IconButton(
//                               icon: Icon(
//                                 isPlaying ? Icons.pause : Icons.play_arrow,
//                                 color: Colors.white,
//                               ),
//                               onPressed: (){
//  setState(() {
//                 isPlaying = !isPlaying;
//               });
//               if (isPlaying) {
//                 playAudioFromFirestore(widget.roomCode);
//               } else {
//                 pauseAudio(widget.roomCode);
//               }
//                               }
//                             ),
//                           ],
//                         )
//                       : const SizedBox(), // Empty container when no song is playing
//                 ),
//               ),


            ],
    );

    }
  },
),
persistentFooterButtons: [
    // Pass the currentSongUrl
    _buildSpotifyPlayer(),
  ],
  

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: Color(0xFF141414)),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            // Logic to navigate to Home Page
            // You can replace the Navigator logic with your specific routing method
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage(roomCode:'roomCode',)),
            );
          } else if (index == 1) {
            // Logic to navigate to Room Page
            // You can replace the Navigator logic with your specific routing method
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CurrentTeamPage(
                        roomCode: '',
                      )),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room),
            label: 'Room',
          ),
        ],
        
      ),
    );
  }

  // Inside your HomePage class
Widget _buildSpotifyPlayer() {
  return BottomAppBar(
    color: Colors.black,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayer(
              roomCode: widget.roomCode,
              filename: currentSongUrl != null ? extractFilenameFromUrl(currentSongUrl!) : "No Song Selected", // Handle null case for filename
            ),
          ),
        ),
        child: currentSongUrl != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.music_note,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        currentSongUrl != null ? extractFilenameFromUrl(currentSongUrl!) : "No Song Selected", // Handle null case for filename display
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow, // Use updated state for play/pause icon
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                      if (isPlaying) {
                        playAudioFromFirestore(widget.roomCode);
                      } else {
                        pauseAudio(widget.roomCode);
                      }
                    },
                  ),
                ],
              )
            : Container(
                child: const Text("No song selected"),
              ),
      ),
    ),
  );
}




}




// Placeholder RoomPage widget
