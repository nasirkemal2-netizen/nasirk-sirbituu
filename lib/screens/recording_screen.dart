import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedFilePath;
  Duration _recordDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  /// -------- Permission ----------
  Future<void> _checkPermission() async {
    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      debugPrint('Microphone permission not granted');
    }
  }

  /// -------- Start Recording ----------
  Future<void> _startRecording() async {
    try {
      if (!await _audioRecorder.hasPermission()) return;

      // Create folder if it doesn't exist
      final dir = Directory('/storage/emulated/0/Sirbituu');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      setState(() {
        _isRecording = true;
        _recordDuration = Duration.zero;
      });

      await _audioRecorder.start(
        const RecordConfig(),
        path: path,
      );

      _updateRecordDuration();
    } catch (e) {
      debugPrint('Recording error: $e');
    }
  }

  /// -------- Stop Recording ----------
  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      _recordedFilePath = path;
    });
  }

  /// -------- Play ----------
  Future<void> _playRecording() async {
    if (_recordedFilePath == null) return;

    setState(() => _isPlaying = true);
    await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => _isPlaying = false);
    });
  }

  /// -------- Stop Playing ----------
  Future<void> _stopPlaying() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }

  /// -------- Timer ----------
  void _updateRecordDuration() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordDuration += const Duration(seconds: 1);
        });
        _updateRecordDuration();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sagalee Galchuu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple.withOpacity(0.1),
                      border: Border.all(
                        color:
                            _isRecording ? Colors.red : Colors.deepPurple,
                        width: 4,
                      ),
                    ),
                    child: Icon(
                      _isRecording ? Icons.mic : Icons.mic_none,
                      size: 60,
                      color: _isRecording ? Colors.red : Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _formatDuration(_recordDuration),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isRecording ? 'Recording...' : 'Ready to record',
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          _isRecording ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _controlButton(
                  icon: _isPlaying ? Icons.stop : Icons.play_arrow,
                  label: _isPlaying ? 'Stop' : 'Play',
                  onPressed:
                      _isPlaying ? _stopPlaying : _playRecording,
                  enabled:
                      _recordedFilePath != null && !_isRecording,
                  color: Colors.green,
                ),
                _controlButton(
                  icon: _isRecording ? Icons.stop : Icons.mic,
                  label: _isRecording ? 'Stop' : 'Record',
                  onPressed:
                      _isRecording ? _stopRecording : _startRecording,
                  enabled: !_isPlaying,
                  color:
                      _isRecording ? Colors.red : Colors.deepPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool enabled,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: enabled ? color : Colors.grey,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: enabled ? onPressed : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: enabled ? color : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}