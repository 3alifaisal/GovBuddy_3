import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class WaveformWidget extends StatelessWidget {
  final Stream<double> amplitudeStream;

  const WaveformWidget({super.key, required this.amplitudeStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: amplitudeStream,
      builder: (context, snapshot) {
        // Normalize dBFS (-160 to 0) to 0.0 - 1.0
        final rawDb = snapshot.data ?? -160.0;
        final normalized = ((rawDb + 60) / 60).clamp(0.1, 1.0); // Clamp to avoid flatline, assume usable range is top 60dB

        return SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(10, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 4,
                height: 10 + (20 * normalized * (index % 2 == 0 ? 1.0 : 0.5)), // Simple variation
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
