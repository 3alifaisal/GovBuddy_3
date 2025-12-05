import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../models/category.dart';
import '../main.dart'; // For AppLang
import '../widgets/search_bar.dart';
import '../core/constants.dart';
import '../services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    widget.searchController.clear();
    
    // Initialize state synchronously if there's an initial query
    // Initialize state synchronously if there's an initial query
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _lastQuestion = widget.initialQuery;
      _fullHistory.add(ChatMessage(role: 'user', content: widget.initialQuery!));

      if (widget.initialResponse != null) {
        // Response is already here! No need to fetch.
        _lastAnswer = widget.initialResponse;
        _isLoading = false;
        _fullHistory.add(ChatMessage(role: 'assistant', content: widget.initialResponse!));
      } else {
        // No response yet, trigger fetch
        _isLoading = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _performSearch(widget.initialQuery!);
        });
      }
    }
  }

  Future<void> _handleSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _lastQuestion = query;
      _lastAnswer = null;
      _isLoading = true;
      _fullHistory.add(ChatMessage(role: 'user', content: query));
    });
    
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
          _lastAnswer = response;
          _isLoading = false;
          _fullHistory.add(ChatMessage(role: 'assistant', content: response));
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastAnswer = widget.currentLang == AppLang.de
              ? 'Entschuldigung, es gab einen Fehler. Bitte versuche es später noch einmal.'
              : 'Sorry, there was an error. Please try again later.';
          _isLoading = false;
          _fullHistory.add(ChatMessage(role: 'assistant', content: _lastAnswer!));
        });
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
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Title & Intro (Show for BOTH General and Specific categories for stability)
              Text(
                widget.category.title.of(widget.currentLang),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Intro Text (Dynamic based on category)
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

              // Specific Category Content (Documents, Info, Sources, Topics)
              if (!isGeneral) ...[
                // Required Documents
                _SectionHeader(
                  title: widget.currentLang == AppLang.de ? 'Erforderliche Unterlagen:' : 'Required documents:',
                ),
                const SizedBox(height: 12),
                ...widget.detail.requiredDocuments.of(widget.currentLang).map((doc) => _BulletPoint(text: doc)),
                const SizedBox(height: 32),

                // Important Info
                _SectionHeader(
                  title: widget.currentLang == AppLang.de ? 'Wichtige Informationen:' : 'Important information:',
                ),
                const SizedBox(height: 12),
                ...widget.detail.importantInfo.of(widget.currentLang).map((info) => _BulletPoint(text: info)),
                const SizedBox(height: 32),

                // Sources
                _SectionHeader(
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
                _SectionHeader(
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
              
              // --- ANSWER SECTION ---
              // Show if we have a question (even if loading)
              // --- ANSWER SECTION ---
              // Show only if we have an answer
              if (_lastAnswer != null && _lastQuestion != null) ...[
                // "Answer to: [Question]"
                Text(
                  widget.currentLang == AppLang.de 
                      ? 'Antwort auf: $_lastQuestion' 
                      : 'Answer to: $_lastQuestion',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // The Answer (Markdown)
                MarkdownBody(
                  data: _lastAnswer!,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, height: 1.6, color: AppColors.textPrimary),
                    h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
                    h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
                    listBullet: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                  ),
                ),
              ],
              
              const SizedBox(height: 40),
            ],
          ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
