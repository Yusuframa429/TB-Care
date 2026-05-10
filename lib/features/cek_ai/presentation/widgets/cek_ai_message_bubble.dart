import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [CekAiMessageBubble] - Bubble chat pesan dari AI.
///
/// Menampilkan avatar robot di kiri dan bubble pesan di kanan
/// dengan timestamp di bawahnya.
///
/// Parameter:
/// - [message]: Teks pesan yang ditampilkan.
/// - [timestamp]: Waktu pesan dikirim (misal: "13:49").
class CekAiMessageBubble extends StatelessWidget {
  final String message;
  final String timestamp;

  const CekAiMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar robot AI.
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),

          /// Bubble pesan + timestamp.
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Bubble pesan.
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                /// Timestamp.
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
