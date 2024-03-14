import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tunedheart/Services/FireStore%20Service/firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _audioFile;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickAudio,
              child: const Text('Pick Audio'),
            ),
            const SizedBox(height: 20),
            _audioFile != null
                ? Text(
                    'Selected Audio: ${_audioFile!.path}',
                    style: const TextStyle(color: Colors.white),
                  )
                : const Text(
                    'No audio selected',
                    style: TextStyle(color: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
}
