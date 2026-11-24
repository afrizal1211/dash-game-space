class CaptureController {
  bool _recording = false;
  bool get recording => _recording;

  Future<void> toggle() async {
    // MediaProjection consent is requested by the Android platform channel.
    _recording = !_recording;
  }
}
