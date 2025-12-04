import 'package:flutter/material.dart';
import '../models/category.dart';
import '../main.dart'; // For AppLang
import '../widgets/hero_section.dart';
import '../widgets/category_card.dart';

class DashboardView extends StatelessWidget {
  final TextEditingController searchController;
  final AppLang currentLang;
  final List<Category> categories;
  final ValueChanged<Category> onCategorySelect;
  final LocalizedText heroTitle;
  final LocalizedText heroSubtitle;
  final LocalizedText searchHint;

  const DashboardView({
    super.key,
    required this.searchController,
    required this.currentLang,
    required this.categories,
    required this.onCategorySelect,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeroSection(
            controller: searchController,
            currentLang: currentLang,
            heroTitle: heroTitle,
            heroSubtitle: heroSubtitle,
            searchHint: searchHint,
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 1;
              if (constraints.maxWidth >= 1024) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth >= 768) {
                crossAxisCount = 2;
              }

              // Calculate aspect ratio or fixed height?
              // React cards have padding and content.
              // Let's use a reasonable aspect ratio or mainAxisExtent if available (Flutter 3.10+).
              // For compatibility, childAspectRatio is standard.
              // A card with title + subtitle + padding is roughly 120-150px high.
              // Width varies. 
              // Let's try childAspectRatio. 
              // If width is ~350, height ~150 => ratio ~ 2.3
              
              // React cards have padding and content.
              // We use mainAxisExtent for fixed height cards.
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 140, // Fixed height for cards
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: categories[index],
                    currentLang: currentLang,
                    onTap: () => onCategorySelect(categories[index]),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
