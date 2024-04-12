import 'package:flutter/material.dart';
import 'package:tunedheart/Objects/audio_detail.dart';

class MusicProvider extends ChangeNotifier {
  AudioDetails? audioDetail;
  String? activeRoomCode;

  setAudioDetails(AudioDetails details) {
    audioDetail = details;
    notifyListeners();
  }

  setActiveRoomCode(String roomCode) {
    activeRoomCode = roomCode;
    notifyListeners();
  }
}
