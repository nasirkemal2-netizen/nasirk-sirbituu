import 'package:flutter/foundation.dart';

class AIProvider extends ChangeNotifier {
  String _selectedStyle = 'oromo_modern';
  String get selectedStyle => _selectedStyle;
  
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;
  
  double _processingProgress = 0.0;
  double get processingProgress => _processingProgress;
  
  String _processingStatus = '';
  String get processingStatus => _processingStatus;
  
  void selectStyle(String style) {
    _selectedStyle = style;
    notifyListeners();
  }
  
  Future<void> generateMusic(String audioPath) async {
    _isProcessing = true;
    _processingProgress = 0.0;
    _processingStatus = 'Starting AI processing...';
    notifyListeners();
    
    // Simulate AI processing steps
    final steps = [
      'Transcribing audio...',
      'Analyzing style: $_selectedStyle...',
      'Generating music...',
      'Applying effects...',
      'Finalizing output...',
    ];
    
    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      _processingProgress = (i + 1) / steps.length;
      _processingStatus = steps[i];
      notifyListeners();
    }
    
    _isProcessing = false;
    notifyListeners();
  }
  
  void reset() {
    _selectedStyle = 'oromo_modern';
    _isProcessing = false;
    _processingProgress = 0.0;
    _processingStatus = '';
    notifyListeners();
  }
}
