import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../models/category.dart';
import '../../../services/api_service.dart';
import '../widgets/hero_section.dart';
import '../widgets/category_card.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/data/content_data.dart';
import 'detail_view.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AppLang _currentLang = AppLang.de;
  Category? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  // Helper to check for existing history
  bool get _hasGeneralHistory => StorageService.instance.getStringList('chat_general')?.isNotEmpty ?? false;
  
  // Store the initial query and response for general search
  String? _initialQuery;
  String? _initialResponse;
  bool _isSearching = false;

  // General Category for Dashboard Search
  final Category _generalCategory = const Category(
    id: 'general',
    title: LocalizedText(de: 'Allgemein', en: 'General'),
    subtitle: LocalizedText(de: '', en: ''),
    color: AppColors.textMuted,
  );
  
  final LocalizedDetail _generalDetail = const LocalizedDetail(
    intro: LocalizedText(de: '', en: ''),
    requiredDocuments: LocalizedList(de: [], en: []),
    importantInfo: LocalizedList(de: [], en: []),
    sources: LocalizedList(de: [], en: []),
    relatedTopics: LocalizedList(de: [], en: []),
  );

  void _toggleLang() {
    setState(() {
      _currentLang = _currentLang == AppLang.de ? AppLang.en : AppLang.de;
    });
  }

  void _handleCategorySelect(Category category) {
    setState(() {
      _selectedCategory = category;
      _initialQuery = null;
      _initialResponse = null;
    });
  }

  void _handleBack() {
    setState(() {
      _selectedCategory = null;
      _initialQuery = null;
      _initialResponse = null;
      _isSearching = false;
    });
  }
  
  Future<void> _handleDashboardSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isSearching = true;
    });

    // Check if we have existing history for General
    final hasHistory = StorageService.instance.getStringList('chat_general')?.isNotEmpty ?? false;

    if (hasHistory) {
        // If history exists, don't fetch a new answer in isolation.
        // Navigate to DetailView and let it handle the context-aware fetch.
        setState(() {
          _initialQuery = query;
          _initialResponse = null; // DetailView will fetch
          _selectedCategory = _generalCategory;
          _isSearching = false;
        });
        return;
    }

    try {
      // Create a temporary history with just this message
      final history = [ChatMessage(role: 'user', content: query)];
      
      // Fetch the response BEFORE navigating
      final response = await _apiService.sendChatRequest(
        history,
        _generalCategory.id,
      );

      if (mounted) {
        setState(() {
          _initialQuery = query;
          _initialResponse = response;
          _selectedCategory = _generalCategory;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // Handle error gracefully - maybe navigate anyway and let DetailView handle it?
        // Or just show error state. For now, let's navigate with error message.
        setState(() {
          _initialQuery = query;
          _initialResponse = _currentLang == AppLang.de
              ? 'Entschuldigung, es gab einen Fehler. Bitte versuche es später noch einmal.'
              : 'Sorry, there was an error. Please try again later.';
          _selectedCategory = _generalCategory;
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ContentData.categories;
    final details = ContentData.details;
    details['general'] = _generalDetail;

    final heroTitle = const LocalizedText(
      de: 'Willkommen in Bremen',
      en: 'Welcome to Bremen',
    );
    final heroSubtitle = const LocalizedText(
      de: 'Dein KI-Begleiter für alle Behördengänge & Fragen.',
      en: 'Your AI companion for all administrative tasks & questions.',
    );
    final searchHint = const LocalizedText(
      de: 'Wonach suchst du heute?',
      en: 'What are you looking for today?',
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: AppColors.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _toggleLang,
                    child: Text(
                      _currentLang == AppLang.de ? 'EN' : 'DE',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedCategory == null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          HeroSection(
                            controller: _searchController,
                            currentLang: _currentLang,
                            heroTitle: heroTitle,
                            heroSubtitle: heroSubtitle,
                            searchHint: searchHint,
                            onSearch: _handleDashboardSearch,
                            isSearching: _isSearching,
                          ),
                          if (_hasGeneralHistory) ...[
                             const SizedBox(height: 20),
                             OutlinedButton.icon(
                               onPressed: () => _handleCategorySelect(_generalCategory),
                               icon: const Icon(Icons.chat_bubble_outline, size: 20),
                               label: Text(
                                 _currentLang == AppLang.de ? 'Konversation fortsetzen' : 'Resume Conversation',
                                 style: const TextStyle(fontWeight: FontWeight.w600),
                               ),
                               style: OutlinedButton.styleFrom(
                                 foregroundColor: AppColors.primary,
                                 side: const BorderSide(color: AppColors.primary),
                                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                               ),
                             ),
                          ],
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: categories.map((cat) {
                                return CategoryCard(
                                  category: cat,
                                  currentLang: _currentLang,
                                  onTap: () => _handleCategorySelect(cat),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : DetailView(
                      key: ValueKey('detail_${_selectedCategory!.id}'),
                      category: _selectedCategory!,
                      detail: details[_selectedCategory!.id]!,
                      currentLang: _currentLang,
                      onBack: _handleBack,
                      searchController: _searchController,
                      initialQuery: _initialQuery,
                      initialResponse: _initialResponse,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
