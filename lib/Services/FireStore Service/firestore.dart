import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunedheart/Services/FireAuth%20Service/authentication.dart';

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
}
