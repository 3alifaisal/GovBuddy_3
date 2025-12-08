import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';
import '../../../core/constants.dart';

class AudioInputButton extends StatefulWidget {
  final ValueChanged<String> onTranscription;
  final VoidCallback? onRecordingStart;
  final Function(bool isRecording, Stream<double>? stream)? onStateChanged;

  const AudioInputButton({
    super.key,
    required this.onTranscription,
    this.onRecordingStart,
    this.onStateChanged,
  });

  @override
  State<AudioInputButton> createState() => _AudioInputButtonState();
}

class _AudioInputButtonState extends State<AudioInputButton> with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  bool _isRecording = false;
  bool _isProcessing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    debugPrint('AUDIO_DEBUG: Toggle recording called. Current state: Recording=$_isRecording, Processing=$_isProcessing');
    if (_isProcessing) return;

    if (_isRecording) {
      debugPrint('AUDIO_DEBUG: Stopping recording...');
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });
      widget.onStateChanged?.call(false, null);

      try {
        final path = await _audioService.stopRecording();
        debugPrint('AUDIO_DEBUG: Recording stopped. Path: $path');
        
        if (path != null) {
          debugPrint('AUDIO_DEBUG: Starting transcription...');
          final text = await _audioService.transcribeAudio(path);
          debugPrint('AUDIO_DEBUG: Transcription received: ${text.substring(0, text.length > 20 ? 20 : text.length)}...');
          if (text.isNotEmpty) {
            widget.onTranscription(text);
          }
        }
      } catch (e) {
        debugPrint('AUDIO_DEBUG: Recording Exception detected: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        debugPrint('AUDIO_DEBUG: Processing finished, resetting state.');
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    } else {
      // Start Recording
      debugPrint('AUDIO_DEBUG: Starting recording flow...');
      widget.onRecordingStart?.call();
      
      final path = await _audioService.startRecording();
      debugPrint('AUDIO_DEBUG: Start recording returned path: $path');
      
      if (path != null) {
        setState(() {
          _isRecording = true;
        });
        widget.onStateChanged?.call(true, _audioService.amplitudeStream);
      } else {
        debugPrint('AUDIO_DEBUG: Start recording FAILED (path is null). Permissions issue?');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRecording,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _isRecording ? Colors.red.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _isRecording
                ? FadeTransition(
                    opacity: _animationController,
                    child: const Icon(Icons.stop, color: Colors.red),
                  )
                : const Icon(Icons.mic, color: AppColors.primary),
      ),
    );
  }
}
