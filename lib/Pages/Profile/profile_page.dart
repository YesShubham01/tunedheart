import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tunedheart/Services/FireStore%20Service/firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _audioFile;
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
      String? url = await FireStore.uploadAudio(_audioFile!);
      if (url != null) {
        FireStore.saveUploadLinktoUserUploads(url);
      } else {
        print("~~~~url is null");
      }
      print(url);
    }
  }


//function for display file name
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
    children: [SingleChildScrollView( // Use SingleChildScrollView for scrollable content
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,40,15,15),
          child: Column(
            children: <Widget>[
              // Profile Text with Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const SizedBox(height: 30,width: 50,),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit Profile'),
                        onTap: () {
                          // Handle edit profile action
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Circular Profile Photo
              const SizedBox(height: 20.0),
              const CircleAvatar(
                radius: 70.0,
                backgroundImage: NetworkImage(
                  // Replace with your default profile image URL
                  "https://firebasestorage.googleapis.com/v0/b/tunedheart-546ef.appspot.com/o/images%2FScreenshot%202023-11-25%20160735.png?alt=media&token=54e76ff0-3aa3-4914-bc7c-d7c1103af5b0",
                ),
              ),

              // Text "YOUR uploads"
              const SizedBox(height: 20.0,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start, // Change to MainAxisAlignment.start
                children: [
                  Text(
                    'Your Uploads',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),

              // List of Songs (replace with your song data fetching/display logic)
              const SizedBox(height: 5.0),
              StreamBuilder(
                  stream: FireStore.userUploadsStream(),
                  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: uploads.length,
        itemBuilder: (context, index) {
          var upload = uploads[index];
          String filename = extractFilenameFromUrl(upload.toString());
          return ListTile(
            contentPadding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 8.0),
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('imageUrl'),
            ),
            title: Text(filename, style: const TextStyle(fontSize: 14, color: Colors.white)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Handle song options (play, edit, delete)
              },
            ),
          );
        },
      );
    }
  },
),

              // Add Icon and _pickAudio cal
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 20.0, // Adjust the positioning as needed
        right: 30.0,
        child: FloatingActionButton(
          onPressed: _pickAudio,
          child: const Icon(Icons.add),
        ),
      ),
    ],
  ),
    );
  }
}


              // Existing
