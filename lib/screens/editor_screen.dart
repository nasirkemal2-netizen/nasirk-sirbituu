import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class EditorScreen extends StatefulWidget {
  final String audioPath;
  final String selectedStyle;
  
  const EditorScreen({
    super.key,
    required this.audioPath,
    required this.selectedStyle,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;
  bool _echoEnabled = false;
  bool _reverbEnabled = false;
  Color _selectedBackground = Colors.deepPurple;
  String _selectedAnimation = 'wave';
  
  final List<Color> _backgroundColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];
  
  final Map<String, IconData> _animations = {
    'wave': Icons.waves,
    'particles': Icons.blur_on,
    'stars': Icons.star,
    'hearts': Icons.favorite,
    'fireworks': Icons.fireplace,
  };

  @override
  void initState() {
    super.initState();
    _initAudio();
  }
  
  Future<void> _initAudio() async {
    await _audioPlayer.setSource(DeviceFileSource(widget.audioPath));
  }
  
  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }
  
  void _updateVolume(double value) {
    setState(() => _volume = value);
    _audioPlayer.setVolume(value);
  }
  
  void _updatePlaybackSpeed(double value) {
    setState(() => _playbackSpeed = value);
    _audioPlayer.setPlaybackRate(value);
  }
  
  void _applyEffect(String effect, bool enabled) {
    // TODO: Implement audio effects
    if (effect == 'echo') {
      setState(() => _echoEnabled = enabled);
    } else if (effect == 'reverb') {
      setState(() => _reverbEnabled = enabled);
    }
  }
  
  void _selectBackground(Color color) {
    setState(() => _selectedBackground = color);
  }
  
  void _selectAnimation(String animation) {
    setState(() => _selectedAnimation = animation);
  }
  
  void _trimAudio() {
    // TODO: Implement audio trimming
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trim Audio'),
        content: const Text('Audio trimming feature will be implemented soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Editor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO: Navigate to export screen
            },
            tooltip: 'Finish Editing',
          ),
        ],
      ),
      body: Column(
        children: [
          // Audio visualization area
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _selectedBackground,
                    _selectedBackground.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated icon based on selection
                    Icon(
                      _animations[_selectedAnimation],
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    
                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: _togglePlayback,
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(
                            Icons.stop,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _audioPlayer.stop();
                            setState(() => _isPlaying = false);
                          },
                        ),
                      ],
                    ),
                    
                    // Style info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Style: ${widget.selectedStyle}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Editor controls
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Volume control
                  _buildControlSection(
                    title: 'Volume',
                    icon: Icons.volume_up,
                    child: Slider(
                      value: _volume,
                      min: 0.0,
                      max: 2.0,
                      divisions: 20,
                      label: _volume.toStringAsFixed(1),
                      onChanged: _updateVolume,
                    ),
                  ),
                  
                  // Playback speed
                  _buildControlSection(
                    title: 'Playback Speed',
                    icon: Icons.speed,
                    child: Slider(
                      value: _playbackSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      label: '${_playbackSpeed}x',
                      onChanged: _updatePlaybackSpeed,
                    ),
                  ),
                  
                  // Audio Effects
                  _buildControlSection(
                    title: 'Audio Effects',
                    icon: Icons.graphic_eq,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildEffectButton(
                          icon: Icons.graphic_eq,
                          label: 'Echo',
                          enabled: _echoEnabled,
                          onToggle: (value) => _applyEffect('echo', value),
                        ),
                        _buildEffectButton(
                          icon: Icons.surround_sound,
                          label: 'Reverb',
                          enabled: _reverbEnabled,
                          onToggle: (value) => _applyEffect('reverb', value),
                        ),
                        _buildEffectButton(
                          icon: Icons.content_cut,
                          label: 'Trim',
                          onTap: _trimAudio,
                        ),
                      ],
                    ),
                  ),
                  
                  // Background Colors
                  _buildControlSection(
                    title: 'Background Color',
                    icon: Icons.color_lens,
                    child: SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _backgroundColors.map((color) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () => _selectBackground(color),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: _selectedBackground == color
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: _selectedBackground == color
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  
                  // Animations
                  _buildControlSection(
                    title: 'Animations',
                    icon: Icons.animation,
                    child: SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _animations.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () => _selectAnimation(entry.key),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _selectedAnimation == entry.key
                                      ? Colors.deepPurple.withValues(alpha: 0.2)
                                      : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _selectedAnimation == entry.key
                                        ? Colors.deepPurple
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Icon(
                                  entry.value,
                                  color: _selectedAnimation == entry.key
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  
                  // Preview Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: _togglePlayback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          const SizedBox(width: 10),
                          Text(
                            _isPlaying ? 'Pause Preview' : 'Preview Edit',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        child,
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildEffectButton({
    required IconData icon,
    required String label,
    bool? enabled,
    Function(bool)? onToggle,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: enabled == true
                ? Colors.deepPurple
                : Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: enabled == true ? Colors.white : Colors.grey,
            ),
            onPressed: onTap ?? () {
              if (onToggle != null && enabled != null) {
                onToggle(!enabled);
              }
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: enabled == true ? Colors.deepPurple : Colors.grey,
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
