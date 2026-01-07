import 'package:flutter/material.dart';

class StyleSelectionScreen extends StatefulWidget {
  final String audioPath;
  
  const StyleSelectionScreen({super.key, required this.audioPath});

  @override
  State<StyleSelectionScreen> createState() => _StyleSelectionScreenState();
}

class _StyleSelectionScreenState extends State<StyleSelectionScreen> {
  String _selectedStyle = 'oromo_modern';
  
  final Map<String, Map<String, dynamic>> _musicStyles = {
    'oromo_modern': {
      'name': 'Oromo Modern',
      'icon': Icons.music_note,
      'color': Colors.purple,
      'description': 'Contemporary Oromo pop music with modern beats',
    },
    'oromo_cultural': {
      'name': 'Oromo Cultural',
      'icon': Icons.public,
      'color': Colors.orange,
      'description': 'Traditional Oromo cultural music with traditional instruments',
    },
    'amhara': {
      'name': 'Amhara Traditional',
      'icon': Icons.landscape,
      'color': Colors.green,
      'description': 'Ethiopian Amhara traditional music',
    },
    'tigray': {
      'name': 'Tigray Cultural',
      'icon': Icons.flag,
      'color': Colors.red,
      'description': 'Tigray cultural and traditional music',
    },
    'ethio_jazz': {
      'name': 'Ethio Jazz',
      'icon': Icons.library_music,
      'color': Colors.blue,
      'description': 'Ethiopian jazz fusion style',
    },
    'pop': {
      'name': 'Pop',
      'icon': Icons.radio,
      'color': Colors.pink,
      'description': 'Modern pop music style',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sirbaa Filachuu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Sirbaa Filadhu:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Garee sirbaa filadhu. AI sirba keetiif uuma.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Styles List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: _musicStyles.entries.map((entry) {
                final style = entry.value;
                final isSelected = _selectedStyle == entry.key;
                
                return _buildStyleCard(
                  title: style['name'] as String,
                  description: style['description'] as String,
                  icon: style['icon'] as IconData,
                  color: style['color'] as Color,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedStyle = entry.key;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          
          // Continue Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                _processWithSelectedStyle();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Sirbaa Uumu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStyleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected ? color.withOpacity(0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: color,
                            size: 24,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _processWithSelectedStyle() {
    // TODO: Process audio with selected style
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('AI Hojjechaa jira'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            Text(
              '$_selectedStyle sirbaa uumuuf hojjechaa jira...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    
    // Simulate AI processing
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close loading dialog
      // TODO: Navigate to editor screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => EditorScreen(audioPath: widget.audioPath, style: _selectedStyle),
      //   ),
      // );
    });
  }
}
