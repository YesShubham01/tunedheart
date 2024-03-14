import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tunedheart/Services/FireAuth%20Service/authentication.dart';
import 'package:path/path.dart' as path;

class FireStore {
  static Future<Map<String, dynamic>?> readRoomData(String roomCode) async {
    try {
      // Get a reference to the "rooms" collection
      CollectionReference roomsRef =
          FirebaseFirestore.instance.collection('rooms');

      // Get the document with ID "1111" from the "rooms" collection
      DocumentSnapshot roomDoc = await roomsRef.doc(roomCode).get();

      // Check if the document exists
      if (roomDoc.exists) {
        // Convert document data into a key-value pair map
        Map<String, dynamic> roomData = roomDoc.data() as Map<String, dynamic>;

        return roomData;
      } else {
        print('Document with ID $roomCode does not exist.');
        return null;
      }
    } catch (e) {
      print('Error reading room data: $e');
      return null;
    }
  }

  static Future<List<dynamic>> readRoomMembers(String roomCode) async {
    try {
      // Get a reference to the "rooms" collection
      CollectionReference roomsRef =
          FirebaseFirestore.instance.collection('rooms');

      // Get the document with ID "1111" from the "rooms" collection
      DocumentSnapshot roomDoc = await roomsRef.doc(roomCode).get();
      List<dynamic> roomMembers = [];
      // Check if the document exists
      if (roomDoc.exists) {
        // Convert document data into a key-value pair map
        roomMembers = roomDoc.get('members');

        return roomMembers;
      } else {
        roomMembers.add(Authenticate.getUserName as String);
        print('Document with ID $roomCode does not exist.');
        return roomMembers;
      }
    } catch (e) {
      print('Error reading room data: $e');
      return [];
    }
  }

  // Function to upload audio file to Firebase Cloud Storage
  static Future<String?> uploadAudio(File audioFile) async {
    try {
      String fileName = path.basename(audioFile.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Songs/$fileName');
      UploadTask uploadTask = storageReference.putFile(audioFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading audio: $e');
      return null;
    }
  }

  static void initialiseUserCollection() async {
    try {
      // Get the current user's ID from Firebase Authentication
      String userId = Authenticate.getUserUid();

      // Create a reference to the user's document in the "Users" collection
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("Users").doc(userId);

      // Check if the document already exists
      DocumentSnapshot userSnapshot = await userRef.get();
      if (!userSnapshot.exists) {
        // Document does not exist, initialize it with the specified data
        await userRef.set({
          'username': Authenticate.getUserName(),
          'rooms': [], // Empty array
          'uploads': [], // Empty array
        });
        print('User collection initialized successfully.');
      } else {
        print('User collection already exists.');
      }
    } catch (e) {
      print('Error initializing user collection: $e');
    }
  }

  static void saveUploadLinktoUserUploads(String url) async {
    try {
      // Get the current user's ID from Firebase Authentication
      String userId = Authenticate.getUserUid();

      // Create a reference to the user's document in the "Users" collection
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("Users").doc(userId);

      // Update the 'uploads' array field in the user's document
      await userRef.update({
        'uploads': FieldValue.arrayUnion([url])
      });

      print('Upload link added to user uploads successfully.');
    } catch (e) {
      print('Error saving upload link to user uploads: $e');
    }
  }
}
