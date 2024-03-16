class AudioDetails {
  final String audioUrl;
  final int currentPosition;
  final bool playbackState;

  AudioDetails(
      {this.audioUrl = '',
      this.currentPosition = 0,
      this.playbackState = false});
}
