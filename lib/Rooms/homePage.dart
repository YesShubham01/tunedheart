import 'package:flutter/material.dart';

import 'current_team.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> songs = [
    {
      'title': 'Love Me Like You Do',
      'singer': 'Ellie Goulding',
      'imageUrl':
          'https://images.app.goo.gl/5nmg3ostzhuvXN6X9', // Replace with actual image URL
    },

    {
      'title': 'Ghost',
      'singer': 'Ellie Goulding',
      'imageUrl':
          'https://images.app.goo.gl/5nmg3ostzhuvXN6X9', // Replace with actual image URL
    },

    {
      'title': 'Prefect',
      'singer': 'Ellie Goulding',
      'imageUrl':
          'https://images.app.goo.gl/5nmg3ostzhuvXN6X9', // Replace with actual image URL
    },

    {
      'title': 'Duniya',
      'singer': 'Ellie Goulding',
      'imageUrl':
          'https://images.app.goo.gl/5nmg3ostzhuvXN6X9', // Replace with actual image URL
    },

    {
      'title': 'Hamsafar',
      'singer': 'Ellie Goulding',
      'imageUrl':
          'https://images.app.goo.gl/5nmg3ostzhuvXN6X9', // Replace with actual image URL
    },

    {
      'title': 'Afreen',
      'singer': 'Ellie Goulding',
      'imageUrl':
          'https://images.app.goo.gl/5nmg3ostzhuvXN6X9', // Replace with actual image URL
    },
    // Add more songs here...
  ];

  int _currentIndex = 0;
  late List<bool> _isPlayingList;

  @override
  void initState() {
    super.initState();
    _initializeIsPlayingList(); // Initialize _isPlayingList in initState
  }

  void _initializeIsPlayingList() {
    _isPlayingList = List.generate(songs.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('DuoStreaming'),
        titleTextStyle: const TextStyle(
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xFF141414),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30, // Increase the avatar size
                backgroundImage: NetworkImage(songs[index]['imageUrl']),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songs[index]['title'],
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white), // Increase title font size
                  ),
                  Text(
                    songs[index]['singer'],
                    style: const TextStyle(
                        fontSize: 14, color: Colors.grey), // Singer name style
                  ),
                ],
              ),
              trailing: IconButton(
                iconSize: 32,
                color: Colors.white, // Increase icon size
                icon: _isPlayingList[index]
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    _isPlayingList[index] = !_isPlayingList[index];
                    // Add logic to play/pause the selected song based on _isPlayingList state
                    if (_isPlayingList[index]) {
                      // Logic to play the song at index
                      // Pause other songs by setting their _isPlayingList value to false
                      for (int i = 0; i < _isPlayingList.length; i++) {
                        if (i != index) {
                          _isPlayingList[i] = false;
                        }
                      }
                    } else {
                      // Logic to pause the song at index
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
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
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            // Logic to navigate to Room Page
            // You can replace the Navigator logic with your specific routing method
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CurrentTeamPage(
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
}


// Placeholder RoomPage widget
