import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
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

// for displaying uploads on profile page
  static Stream<List<dynamic>> userUploadsStream() async* {
    try {
      // Get the current user's ID
      String userId = Authenticate.getUserUid();

      // Create a reference to the user's document in the "users" collection
      DocumentReference userRef =
          FirebaseFirestore.instance.collection("Users").doc(userId);

      // Create a snapshot stream of the user's document
      Stream<DocumentSnapshot> snapshotStream = userRef.snapshots();

      // Yield the mapped stream
      yield* snapshotStream.map((doc) {
        if (doc.exists) {
          final userData = doc.data() as Map<String, dynamic>;
          if (userData.containsKey('uploads')) {
            // Accessing 'uploads' array from user data
            final uploads = userData['uploads'] as List<dynamic>;
            // Convert 'uploads' to List<List<String>>
            return uploads;
          } else {
            // 'uploads' field doesn't exist or is null
            return [];
          }
        } else {
          // Document does not exist
          throw Exception("User document does not exist");
        }
      });
    } catch (e) {
      // Handle errors
      print("Error fetching user uploads: $e");
      throw Exception("Failed to fetch user uploads");
    }
  }

  // static Future<List<String>> fetchArraysFromRoom(String roomCode) async {
  // try {
  //   // Get a reference to the "ChatRoom" collection
  //   CollectionReference roomRef =
  //       FirebaseFirestore.instance.collection('ChatRoom');

  //   // Get the document with the provided roomCode
  //   DocumentSnapshot roomDoc = await roomRef.doc(roomCode).get();

  //   // Check if the document exists
  //   if (roomDoc.exists) {
  //     // Retrieve the data from the document
  //     Object data = roomDoc.data()!;

  //     // Check if the document contains an array
  //   } else {
  //     print('Document with room code $roomCode does not exist');
  //     return [];
  //   }
  // } catch (e) {
  //   print('Error fetching arrays: $e');
  //   return [];
  // }

  static Future<List<dynamic>> getMessagesInRoom(String roomId) async {
    try {
      // Get a reference to the "ChatRoom" collection
      CollectionReference roomsRef =
          FirebaseFirestore.instance.collection('ChatRoom');

      // Get the document with the given roomId
      DocumentSnapshot roomDoc = await roomsRef.doc(roomId).get();

      // Check if the document exists
      if (roomDoc.exists) {
        // Extract the "messages" array from the document
        Map<String, dynamic> data = roomDoc.data() as Map<String, dynamic>;
        List<dynamic> messages = data['messages'];

        return messages;
      } else {
        print('Document with ID $roomId does not exist.');
        return [];
      }
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

// Add a new message to the ChatRoom document
  static Future<void> addMessageToRoom(String roomId, String message) async {
    try {
      // Get a reference to the "ChatRoom" collection
      CollectionReference roomsRef =
          FirebaseFirestore.instance.collection('ChatRoom');

      // Get the document reference for the room
      DocumentReference roomDocRef = roomsRef.doc(roomId);

      // Update the room document with the new message
      await roomDocRef.update({
        'messages': FieldValue.arrayUnion([message])
      });

      print('Message added successfully to room $roomId');
    } catch (e) {
      print('Error adding message to room: $e');
    }
  }
}
