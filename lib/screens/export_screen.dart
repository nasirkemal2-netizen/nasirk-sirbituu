import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ExportScreen extends StatefulWidget {
  final String audioPath;
  final String style;
  final Color backgroundColor;
  final String animationType;
  
  const ExportScreen({
    super.key,
    required this.audioPath,
    required this.style,
    required this.backgroundColor,
    required this.animationType,
  });

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool _isExporting = false;
  double _exportProgress = 0.0;
  String _exportStatus = 'Ready to export';
  String? _exportedFilePath;
  
  final List<Map<String, dynamic>> _exportOptions = [
    {
      'format': 'MP3',
      'icon': Icons.audio_file,
      'description': 'Audio only, small file size',
      'quality': 'High',
      'size': '~3-5 MB',
    },
    {
      'format': 'MP4',
      'icon': Icons.video_file,
      'description': 'Video with background animation',
      'quality': 'High',
      'size': '~10-20 MB',
    },
    {
      'format': 'WAV',
      'icon': Icons.high_quality,
      'description': 'Lossless audio quality',
      'quality': 'Lossless',
      'size': '~20-30 MB',
    },
  ];
  
  String _selectedFormat = 'MP4';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Preview section
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.backgroundColor,
                    widget.backgroundColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success icon or loading
                    _isExporting
                        ? CircularProgressIndicator(
                            value: _exportProgress,
                            color: Colors.white,
                            strokeWidth: 4,
                          )
                        : const Icon(
                            Icons.check_circle,
                            size: 80,
                            color: Colors.white,
                          ),
                    
                    const SizedBox(height: 20),
                    
                    // Status text
                    Text(
                      _isExporting ? 'Exporting...' : 'Ready to Export!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Progress text
                    Text(
                      _exportStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    if (_isExporting)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: LinearProgressIndicator(
                          value: _exportProgress,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Export options and controls
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Export format selection
                  const Text(
                    'Export Format:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  ..._exportOptions.map((option) {
                    return _buildFormatOption(
                      format: option['format'] as String,
                      icon: option['icon'] as IconData,
                      description: option['description'] as String,
                      quality: option['quality'] as String,
                      size: option['size'] as String,
                      isSelected: _selectedFormat == option['format'],
                    );
                  }),
                  
                  const SizedBox(height: 30),
                  
                  // File details
                  _buildDetailCard(
                    icon: Icons.info,
                    title: 'File Details',
                    children: [
                      _buildDetailRow('Style', widget.style),
                      _buildDetailRow('Background', 'Color #${widget.backgroundColor.value.toRadixString(16)}'),
                      _buildDetailRow('Animation', widget.animationType),
                      _buildDetailRow('Format', _selectedFormat),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Action buttons
                  if (!_isExporting && _exportedFilePath == null)
                    Column(
                      children: [
                        // Export button
                        ElevatedButton(
                          onPressed: _startExport,
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
                                Icon(Icons.download, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Export File',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // Share button (disabled until export)
                        OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.deepPurple),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share, color: Colors.deepPurple),
                                SizedBox(width: 12),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  // After export buttons
                  if (_exportedFilePath != null)
                    Column(
                      children: [
                        // Success message
                        Card(
                          color: Colors.green.withOpacity(0.1),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Export successful! File saved to device.',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Share exported file
                        ElevatedButton(
                          onPressed: _shareFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Share File',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // New project button
                        OutlinedButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.deepPurple),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle, color: Colors.deepPurple),
                                SizedBox(width: 12),
                                Text(
                                  'New Project',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFormatOption({
    required String format,
    required IconData icon,
    required String description,
    required String quality,
    required String size,
    required bool isSelected,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() => _selectedFormat = format);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurple : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          format,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.deepPurple : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Colors.deepPurple,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          label: Text(quality),
                          backgroundColor: Colors.green.withOpacity(0.2),
                          labelStyle: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(size),
                          backgroundColor: Colors.blue.withOpacity(0.2),
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
  
  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
  
  Future<void> _startExport() async {
    setState(() {
      _isExporting = true;
      _exportProgress = 0.0;
      _exportStatus = 'Preparing export...';
    });
    
    // Simulate export process
    const totalSteps = 5;
    for (int step = 1; step <= totalSteps; step++) {
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _exportProgress = step / totalSteps;
        
        switch (step) {
          case 1:
            _exportStatus = 'Processing audio...';
            break;
          case 2:
            _exportStatus = 'Applying effects...';
            break;
          case 3:
            _exportStatus = 'Adding background...';
            break;
          case 4:
            _exportStatus = 'Encoding $_selectedFormat file...';
            break;
          case 5:
            _exportStatus = 'Saving to device...';
            break;
        }
      });
    }
    
    // Export complete
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isExporting = false;
      _exportedFilePath = '/storage/emulated/0/Kumkummee/export_${DateTime.now().millisecondsSinceEpoch}.${_selectedFormat.toLowerCase()}';
      _exportStatus = 'Export complete!';
    });
  }
  
  Future<void> _shareFile() async {
    if (_exportedFilePath != null) {
      await Share.shareXFiles([
        XFile(_exportedFilePath!),
      ], text: 'Check out my Kumkummee creation! 🎵');
    }
  }
}
