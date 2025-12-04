import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/category.dart'; // For LocalizedText
import '../main.dart'; // For AppLang
import 'search_bar.dart';

class HeroSection extends StatelessWidget {
  final TextEditingController controller;
  final AppLang currentLang;
  final LocalizedText heroTitle;
  final LocalizedText heroSubtitle;
  final LocalizedText searchHint;

  const HeroSection({
    super.key,
    required this.controller,
    required this.currentLang,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.subtleBorder),
            boxShadow: AppShadows.soft,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/govbuddy_logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.pets, size: 48, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          heroTitle.of(currentLang),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 620,
          child: Text(
            heroSubtitle.of(currentLang),
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        AppSearchBar(
          controller: controller,
          hint: searchHint.of(currentLang),
        ),
      ],
    );
  }
}
