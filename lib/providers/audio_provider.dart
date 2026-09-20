
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioProvider with ChangeNotifier {
  final AudioRecorder _record = AudioRecorder();

  bool _isRecording = false;
  String? _recordedFilePath;

  bool get isRecording => _isRecording;
  String? get recordedFilePath => _recordedFilePath;

  /// Start audio recording
  Future<void> startRecording() async {
    try {
      final hasPermission = await _record.hasPermission();
      if (!hasPermission) {
        debugPrint('Microphone permission not granted');
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      _isRecording = true;
      _recordedFilePath = filePath;
      notifyListeners();
    } catch (e) {
      debugPrint('Start recording error: $e');
    }
  }

  /// Stop audio recording
  Future<void> stopRecording() async {
    try {
      final path = await _record.stop();
      if (path != null) {
        _recordedFilePath = path;
      }

      _isRecording = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Stop recording error: $e');
    }
  }

  /// Dispose recorder
  @override
  void dispose() {
    _record.dispose();
    super.dispose();
  }
}
