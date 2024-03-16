import 'package:flutter/material.dart';
import 'package:tunedheart/Objects/audio_detail.dart';

class MusicProvider extends ChangeNotifier {
  AudioDetails? audioDetail;

  setAudioDetails(AudioDetails details) {
    audioDetail = details;
  }
}
