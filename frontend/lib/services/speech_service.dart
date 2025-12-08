import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

/// Service for handling speech-to-text using device capabilities
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  String _lastError = '';

  String get lastError => _lastError;

  /// Initialize the speech recognizer
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      _lastError = '';
      // On Web, this triggers permission prompt automatically
      _isInitialized = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) {
          print('Speech error: $error');
          _lastError = error.errorMsg;
        },
        debugLogging: true,
      );

      return _isInitialized;
    } catch (e) {
      print('Error initializing speech service: $e');
      _lastError = e.toString();
      return false;
    }
  }

  final _soundLevelController = StreamController<double>.broadcast();
  Stream<double> get soundLevelStream => _soundLevelController.stream;

  /// Start listening for speech
  /// 
  /// [onResult] callback is triggered whenever recognized text changes
  Future<void> startListening({
    required Function(String) onResult,
    String localeId = 'de-DE',
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      onSoundLevelChange: (level) {
        _soundLevelController.add(level);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: localeId,
      cancelOnError: true,
      listenMode: stt.ListenMode.dictation,
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speech.stop();
  }

  /// Check if currently listening
  bool get isListening => _speech.isListening;
  
  /// Check if available
  bool get isAvailable => _speech.isAvailable;
  
  void dispose() {
    _soundLevelController.close();
  }
}
