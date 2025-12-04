import 'package:flutter/material.dart';
import '../core/constants.dart';

/// Side panel that lists a user's past questions.
class HistoryPanel extends StatelessWidget {
  final List<String> historyItems;

  const HistoryPanel({super.key, required this.historyItems});

  @override
  Widget build(BuildContext context) {
    // On mobile, this might be hidden or a drawer.
    // React implementation shows it on the left for desktop.
    // We'll keep the current implementation which seems to be desktop-focused or responsive.
    // If screen is small, we might want to hide it.
    
    // For now, just porting the code.
    return Container(
      width: 230,
      margin: const EdgeInsets.fromLTRB(16, 24, 8, 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.subtleBorder),
        boxShadow: AppShadows.soft,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 120,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.badge,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Only visible when logged in',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.history, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  const Text(
                    'History',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...historyItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _HistoryItem(label: item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single history entry pill.
class _HistoryItem extends StatelessWidget {
  final String label;

  const _HistoryItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.badge,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.subtleBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
