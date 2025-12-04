import 'package:flutter/material.dart';
import '../models/category.dart';
import '../main.dart'; // For AppLang
import '../widgets/search_bar.dart';
import '../core/constants.dart';

class DetailView extends StatelessWidget {
  final Category category;
  final LocalizedDetail detail;
  final AppLang currentLang;
  final VoidCallback onBack;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const DetailView({
    super.key,
    required this.category,
    required this.detail,
    required this.currentLang,
    required this.onBack,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    // We need a Stack to place the search bar at the bottom fixed.
    // Or use a Column with Expanded and the search bar at bottom.
    // React uses `fixed bottom-0`.
    
    return Stack(
      children: [
        // Main Content
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // Bottom padding for search bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button (Optional, but good for UX)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, size: 20, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Text(
                          currentLang == AppLang.de ? 'Zurück' : 'Back',
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

              // Title
              Text(
                category.title.of(currentLang),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Intro
              Text(
                detail.intro.of(currentLang),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // Required Documents
              _SectionHeader(
                title: currentLang == AppLang.de ? 'Erforderliche Unterlagen:' : 'Required documents:',
              ),
              const SizedBox(height: 12),
              ...detail.requiredDocuments.of(currentLang).map((doc) => _BulletPoint(text: doc)),
              const SizedBox(height: 32),

              // Important Info
              _SectionHeader(
                title: currentLang == AppLang.de ? 'Wichtige Informationen:' : 'Important information:',
              ),
              const SizedBox(height: 12),
              ...detail.importantInfo.of(currentLang).map((info) => _BulletPoint(text: info)),
              const SizedBox(height: 32),

              // Sources
              _SectionHeader(
                title: currentLang == AppLang.de ? 'Quellen in Bremen' : 'Sources in Bremen',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: detail.sources.of(currentLang).map((source) {
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
                title: currentLang == AppLang.de ? 'Verwandte Themen' : 'Related topics',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: detail.relatedTopics.of(currentLang).map((topic) {
                  // In React, these had specific colors. Here we'll use a generic style or map colors if possible.
                  // For now, using a default color.
                  return Chip(
                    label: Text(topic),
                    backgroundColor: category.color,
                    labelStyle: const TextStyle(color: Colors.white),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Fixed Bottom Search Bar
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
            child: Center(
              child: AppSearchBar(
                controller: searchController,
                hint: currentLang == AppLang.de ? 'Stell eine Folgefrage...' : 'Ask a follow-up question...',
                isCompact: true,
              ),
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
