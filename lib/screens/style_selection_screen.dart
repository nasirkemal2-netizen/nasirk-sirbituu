import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_provider.dart';

class StyleSelectionScreen extends StatelessWidget {
  const StyleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIProvider>(context);
    
    final styles = [
      {
        'id': 'oromo_modern',
        'name': 'Oromo Modern',
        'description': 'Contemporary Oromo music with modern beats',
        'color': Colors.deepPurple,
        'icon': Icons.music_note,
      },
      {
        'id': 'oromo_traditional',
        'name': 'Oromo Traditional',
        'description': 'Classical Oromo cultural music',
        'color': Colors.green,
        'icon': Icons.library_music,
      },
      {
        'id': 'amhara',
        'name': 'Amhara',
        'description': 'Ethiopian Amhara style music',
        'color': Colors.blue,
        'icon': Icons.piano,
      },
      {
        'id': 'tigray',
        'name': 'Tigray',
        'description': 'Tigray cultural music style',
        'color': Colors.orange,
        'icon': Icons.graphic_eq,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Music Style'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pushNamed(context, '/edit');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];
          final isSelected = aiProvider.selectedStyle == style['id'];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: isSelected 
                ? (style['color'] as Color).withValues(alpha: 0.1)
                : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (style['color'] as Color).withValues(alpha: 0.2),
                child: Icon(
                  style['icon'] as IconData,
                  color: style['color'] as Color,
                ),
              ),
              title: Text(
                style['name'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? style['color'] as Color : null,
                ),
              ),
              subtitle: Text(style['description'] as String),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.deepPurple)
                  : null,
              onTap: () {
                aiProvider.selectStyle(style['id'] as String);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/edit');
        },
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Continue to Editor'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
