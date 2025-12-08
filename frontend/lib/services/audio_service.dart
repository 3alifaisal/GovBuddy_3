// Audio service for speech-to-text functionality.
//
// This service handles audio recording, permissions, and transcription.
// Compatible with Web, Mobile, and Desktop.

import 'dart:convert';
import 'dart:io' show Directory, File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../services/api_service.dart';

/// Service for handling audio recording and transcription
class AudioService {
  /// Audio recorder instance
  final AudioRecorder _recorder = AudioRecorder();
  
  // Stream for amplitude
  // Stream for amplitude
  Stream<double>? _amplitudeStream;
  Stream<double> get amplitudeStream {
    _amplitudeStream ??= _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .map((amp) => amp.current)
        .asBroadcastStream();
    return _amplitudeStream!;
  }

  
  /// Check if currently recording
  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }
  
  /// Check microphone permission status
  Future<PermissionStatus> checkPermission() async {
    if (kIsWeb) {
      return PermissionStatus.granted;
    }
    return await Permission.microphone.status;
  }
  
  /// Request microphone permission
  Future<bool> requestPermission() async {
    try {
      if (kIsWeb) return true;
      
      final status = await Permission.microphone.status;
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) return false;
      
      final result = await Permission.microphone.request();
      return result.isGranted;
    } catch (e) {
      print('Error requesting microphone permission: $e');
      return false;
    }
  }
  
  /// Open app settings
  Future<bool> openSettings() async {
    if (kIsWeb) return false;
    return await openAppSettings();
  }
  
  /// Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    if (kIsWeb) return false;
    final status = await Permission.microphone.status;
    return status.isPermanentlyDenied;
  }
  
  /// Start recording audio
  Future<String?> startRecording() async {
    try {
      if (!await requestPermission()) return null;
      
      String? filePath;
      
      if (kIsWeb) {
        // Web: Record to memory (Stream) or Blob
        // Passing empty path to record to memory/blob
        filePath = ''; 
      } else {
        // Mobile/Desktop: Record to file
        final tempDir = Directory.systemTemp;
        filePath = '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      }
      
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );
      
      return filePath;
    } catch (e) {
      print('Error starting recording: $e');
      return null;
    }
  }
  
  /// Stop recording
  Future<String?> stopRecording() async {
    try {
      final path = await _recorder.stop();
      return path;
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    }
  }
  
  /// Transcribe audio file to text
  Future<String> transcribeAudio(String path) async {
    try {
      final uri = Uri.parse('${ApiService.baseUrl}/speech/transcribe');
      final request = http.MultipartRequest('POST', uri);
      
      if (kIsWeb) {
        // Web: Path is a Blob URL (blob:http://...)
        // We need to fetch the blob data first
        final response = await http.get(Uri.parse(path));
        final bytes = response.bodyBytes;
        
        request.files.add(
          http.MultipartFile.fromBytes(
            'audio',
            bytes,
            filename: 'recording.webm',
            contentType: MediaType('audio', 'webm'), // Explicitly set content type
          ),
        );
      } else {
        // Mobile/Desktop: Path is a file path
        request.files.add(
          await http.MultipartFile.fromPath(
            'audio',
            path,
            filename: 'recording.m4a',
          ),
        );
      }
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['text'] ?? '';
      } else {
        throw Exception('Transcription failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error transcribing audio: $e');
      throw Exception('Failed to transcribe audio. Please try again.');
    } finally {
      // Cleanup
      if (!kIsWeb) {
        try {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          print('Error deleting temp file: $e');
        }
      }
    }
  }
  
  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
