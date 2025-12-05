import 'package:flutter/material.dart';
import '../core/constants.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isCompact;
  final ValueChanged<String>? onSubmitted;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    this.isCompact = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? double.infinity : 700,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.subtleBorder),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textMuted),
                isDense: true,
              ),
            ),
          ),
          if (!isCompact) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.subtleBorder),
              ),
              child: const Text(
                'AI-powered',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
