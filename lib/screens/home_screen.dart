import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../screens/recording_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kumkummee',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Open settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated music icon
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Lottie.asset(
                  'assets/animations/music_wave.json',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Welcome text
            const Text(
              'Baga Nagaan Dhuftan!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sirba Afaan Oromoo AI waliin uumu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            
            // Action buttons
            _buildActionButton(
              icon: Icons.mic,
              text: 'Sagalee Galchuu',
              subtitle: 'Record your voice',
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecordingScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            _buildActionButton(
              icon: Icons.upload_file,
              text: 'Audio Import',
              subtitle: 'Import existing audio',
              color: Colors.blue,
              onTap: () {
                // TODO: Import audio
              },
            ),
            const SizedBox(height: 20),
            
            _buildActionButton(
              icon: Icons.music_note,
              text: 'Sirboota',
              subtitle: 'Browse sample music',
              color: Colors.green,
              onTap: () {
                // TODO: Browse samples
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                radius: 25,
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
