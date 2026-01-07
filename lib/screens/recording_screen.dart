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
    _initRecorder();
  }
  
  Future<void> _initRecorder() async {
    final status = await Record().hasPermission();
    if (!status) {
      // Handle permission denied
    }
  }
  
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
          _recordDuration = Duration.zero;
        });
        
        // Start recording
        final path = '/storage/emulated/0/Kumkummee/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        
        // Update duration
        _updateRecordDuration();
      }
    } catch (e) {
      print('Recording error: $e');
    }
  }
  
  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      _recordedFilePath = path;
    });
  }
  
  Future<void> _playRecording() async {
    if (_recordedFilePath != null) {
      setState(() => _isPlaying = true);
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      
      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() => _isPlaying = false);
      });
    }
  }
  
  Future<void> _stopPlaying() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }
  
  void _updateRecordDuration() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordDuration = _recordDuration + const Duration(seconds: 1);
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
        actions: [
          if (_recordedFilePath != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // TODO: Navigate to style selection
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Recording visualization
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated recording circle
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple.withOpacity(0.1),
                      border: Border.all(
                        color: _isRecording ? Colors.red : Colors.deepPurple,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _isRecording ? Icons.mic : Icons.mic_none,
                        size: 60,
                        color: _isRecording ? Colors.red : Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Recording duration
                  Text(
                    _formatDuration(_recordDuration),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Status text
                  Text(
                    _isRecording ? 'Recording...' : 'Ready to record',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isRecording ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Control buttons
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Play button
                _buildControlButton(
                  icon: _isPlaying ? Icons.stop : Icons.play_arrow,
                  label: _isPlaying ? 'Stop' : 'Play',
                  onPressed: _isPlaying ? _stopPlaying : _playRecording,
                  color: Colors.green,
                  enabled: _recordedFilePath != null && !_isRecording,
                ),
                
                // Record button
                _buildControlButton(
                  icon: _isRecording ? Icons.stop : Icons.mic,
                  label: _isRecording ? 'Stop' : 'Record',
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  color: _isRecording ? Colors.red : Colors.deepPurple,
                  enabled: !_isPlaying,
                ),
                
                // Save button
                _buildControlButton(
                  icon: Icons.save,
                  label: 'Save',
                  onPressed: _recordedFilePath != null ? () {
                    // TODO: Save and continue
                  } : null,
                  color: Colors.blue,
                  enabled: _recordedFilePath != null && !_isRecording,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
    required bool enabled,
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
