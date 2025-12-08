import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../../models/category.dart';
import '../widgets/search_bar.dart';
import '../widgets/audio_input_button.dart';
import '../widgets/section_header.dart';
import '../widgets/bullet_point.dart';
import '../../../core/constants.dart';
import '../../../services/api_service.dart';
import 'dart:convert';
import '../widgets/chat_bubble.dart'; 
import '../../../core/services/storage_service.dart';

class DetailView extends StatefulWidget {
  final Category category;
  final LocalizedDetail detail;
  final AppLang currentLang;
  final VoidCallback onBack;
  final TextEditingController searchController;
  final String? initialQuery;
  final String? initialResponse;

  const DetailView({
    super.key,
    required this.category,
    required this.detail,
    required this.currentLang,
    required this.onBack,
    required this.searchController,
    this.initialQuery,
    this.initialResponse,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final ApiService _apiService = ApiService();
  
  String? _lastQuestion;
  String? _lastAnswer;
  final List<ChatMessage> _fullHistory = [];
  
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  
  // Recording State
  bool _isVoiceRecording = false;
  Stream<double>? _amplitudeStream;

  @override
  void initState() {
    super.initState();
    widget.searchController.clear();
    super.initState();
    widget.searchController.clear();
    
    // Load history first, then process initial query if needed
    _loadHistory().then((_) {
        if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
           // Avoid duplicates: Check if the last user message matches the new query
           final lastUserMsg = _fullHistory.lastWhere(
              (m) => m.role == 'user', 
              orElse: () => ChatMessage(role: 'system', content: '')
           );
           
           if (lastUserMsg.content != widget.initialQuery) {
               setState(() {
                  _fullHistory.add(ChatMessage(role: 'user', content: widget.initialQuery!));
                  if (widget.initialResponse != null) {
                      _fullHistory.add(ChatMessage(role: 'assistant', content: widget.initialResponse!));
                  }
               });
               
               if (widget.initialResponse == null) {
                   // If no response provided (e.g. from generic navigation), fetch it now
                   _isLoading = true; // Show loading
                   _performSearch(widget.initialQuery!);
               }
               
               _saveHistory();
               _scrollToBottom();
           }
        }
    });
  }

  Future<void> _loadHistory() async {
      final key = 'chat_${widget.category.id}';
      final jsonList = StorageService.instance.getStringList(key);
      if (jsonList != null) {
          setState(() {
              _fullHistory.clear();
              _fullHistory.addAll(
                  jsonList.map((str) => ChatMessage.fromJson(jsonDecode(str))).toList()
              );
          });
          _scrollToBottom();
      }
  }

  Future<void> _saveHistory() async {
      final key = 'chat_${widget.category.id}';
      final jsonList = _fullHistory.map((m) => jsonEncode(m.toJson())).toList();
      await StorageService.instance.setStringList(key, jsonList);
  }

  Future<void> _handleSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _fullHistory.add(ChatMessage(role: 'user', content: query));
    });
    
    _saveHistory();
    
    widget.searchController.clear();
    _scrollToBottom();
    
    await _performSearch(query);
  }
  
  Future<void> _performSearch(String query) async {
    try {
      final response = await _apiService.sendChatRequest(
        _fullHistory,
        widget.category.id,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _fullHistory.add(ChatMessage(role: 'assistant', content: response));
        });
        _saveHistory();
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          final errorMsg = widget.currentLang == AppLang.de
              ? 'Entschuldigung, es gab einen Fehler. Bitte versuche es später noch einmal.'
              : 'Sorry, there was an error. Please try again later.';
          _isLoading = false;
          _fullHistory.add(ChatMessage(role: 'assistant', content: errorMsg));
        });
        _saveHistory();
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGeneral = widget.category.id == 'general';

    return Stack(
      children: [
        // Main Content
        // SingleChildScrollView replaced by Column + Expanded ListView
        Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                children: [
                  // --- HEADER SECTION (Intro, Docs, etc) ---
                  // Back Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: widget.onBack,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_back, size: 20, color: AppColors.textMuted),
                            const SizedBox(width: 8),
                            Text(
                              widget.currentLang == AppLang.de ? 'Zurück' : 'Back',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Title & Intro
                  Text(
                    widget.category.title.of(widget.currentLang),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Intro Text
                  Text(
                    isGeneral 
                        ? (widget.currentLang == AppLang.de 
                            ? 'Ich helfe dir bei allgemeinen Fragen zu Bremen.' 
                            : 'I can help you with general questions about Bremen.')
                        : widget.detail.intro.of(widget.currentLang),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Specific Category Content
                  if (!isGeneral) ...[
                    // Required Documents
                    SectionHeader(
                      title: widget.currentLang == AppLang.de ? 'Erforderliche Unterlagen:' : 'Required documents:',
                    ),
                    const SizedBox(height: 12),
                    ...widget.detail.requiredDocuments.of(widget.currentLang).map((doc) => BulletPoint(text: doc)),
                    const SizedBox(height: 32),

                    // Important Info
                    SectionHeader(
                      title: widget.currentLang == AppLang.de ? 'Wichtige Informationen:' : 'Important information:',
                    ),
                    const SizedBox(height: 12),
                    ...widget.detail.importantInfo.of(widget.currentLang).map((info) => BulletPoint(text: info)),
                    const SizedBox(height: 32),

                    // Sources
                    SectionHeader(
                      title: widget.currentLang == AppLang.de ? 'Quellen in Bremen' : 'Sources in Bremen',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.detail.sources.of(widget.currentLang).map((source) {
                        return Chip(
                          label: Text(source),
                          backgroundColor: AppColors.badge,
                          labelStyle: const TextStyle(color: AppColors.textPrimary),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Related Topics
                    SectionHeader(
                      title: widget.currentLang == AppLang.de ? 'Verwandte Themen' : 'Related topics',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.detail.relatedTopics.of(widget.currentLang).map((topic) {
                        return Chip(
                          label: Text(topic),
                          backgroundColor: widget.category.color,
                          labelStyle: const TextStyle(color: Colors.white),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 48),
                    const Divider(height: 1, color: AppColors.subtleBorder),
                    const SizedBox(height: 32),
                  ],
                  
                  // --- CHAT HISTORY SECTION ---
                  if (_fullHistory.isEmpty) 
                     Center(
                       child: Text(
                         widget.currentLang == AppLang.de ? 'Noch keine Nachrichten...' : 'No messages yet...',
                         style: const TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic),
                       ),
                     ),
                  
                  ..._fullHistory.map((msg) => ChatBubble(
                    message: msg, 
                    isDarkMode: false, // Default
                    bubbleColor: widget.category.color,
                  )),
                  
                  // Bottom Padding for Input Area
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),

        // Fixed Bottom Area (Thinking Text + Search Bar)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.background,
                  AppColors.background.withOpacity(0.9),
                  AppColors.background.withOpacity(0.0),
                ],
                stops: const [0.6, 0.8, 1.0],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thinking Text
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      widget.currentLang == AppLang.de ? 'Denke nach...' : 'Thinking...',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                // Search Bar
                Center(
                    child: AppSearchBar(
                      controller: widget.searchController,
                      hint: widget.currentLang == AppLang.de ? 'Stell eine Folgefrage...' : 'Ask a follow-up question...',
                      isCompact: true,
                      onSubmitted: _handleSearch,
                      showIcon: false, // Requested by user
                      isRecording: _isVoiceRecording,
                      amplitudeStream: _amplitudeStream,
                      suffix: AudioInputButton(
                        onTranscription: (text) {
                          _handleSearch(text);
                        },
                        onStateChanged: (isRec, stream) {
                           setState(() {
                             _isVoiceRecording = isRec;
                             _amplitudeStream = stream;
                           });
                        },
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

