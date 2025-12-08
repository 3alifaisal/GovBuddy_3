import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import 'waveform_widget.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isCompact;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final bool showIcon;
  final bool isRecording;
  final Stream<double>? amplitudeStream;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    this.isCompact = false,
    this.onSubmitted,
    this.suffix,
    this.showIcon = true,
    this.isRecording = false,
    this.amplitudeStream,
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
          if (showIcon && !isRecording) ...[
            const Icon(Icons.search, color: AppColors.textMuted),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: isRecording
                ? WaveformWidget(amplitudeStream: amplitudeStream ?? const Stream.empty())
                : TextField(
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
          if (suffix != null) ...[
            const SizedBox(width: 8),
            suffix!,
          ] else if (!isCompact && !isRecording) ...[
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
