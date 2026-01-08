import 'package:flutter/foundation.dart';
import 'package:audio_recorder/audio_recorder.dart';  // CHANGED

class AudioProvider extends ChangeNotifier {
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  
  String? _recordedFilePath;
  String? get recordedFilePath => _recordedFilePath;
  
  Duration _recordingDuration = Duration.zero;
  Duration get recordingDuration => _recordingDuration;
  
  Future<void> startRecording() async {
    if (await AudioRecorder.hasPermissions) {
      _isRecording = true;
      _recordingDuration = Duration.zero;
      notifyListeners();
      
      final path = '/storage/emulated/0/Sirbituu/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await AudioRecorder.start(path: path);
      _recordedFilePath = path;
      
      _updateDuration();
    }
  }
  
  Future<void> stopRecording() async {
    await AudioRecorder.stop();
    _isRecording = false;
    notifyListeners();
  }
  
  void _updateDuration() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        _recordingDuration += const Duration(seconds: 1);
        notifyListeners();
        _updateDuration();
      }
    });
  }
  
  void reset() {
    _isRecording = false;
    _recordedFilePath = null;
    _recordingDuration = Duration.zero;
    notifyListeners();
  }
}
