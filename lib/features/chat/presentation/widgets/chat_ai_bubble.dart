import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ChatAiBubble] - Bubble chat pesan dari AI Asisten.
///
/// Menampilkan avatar robot hijau di kiri dan bubble pesan putih
/// di kanan dengan timestamp di bawahnya. Desain konsisten
/// dengan `CekAiMessageBubble` di fitur Cek AI.
///
/// Parameter:
/// - [message]: Teks pesan AI.
/// - [timestamp]: Waktu pesan (misal: "14:02").
class ChatAiBubble extends StatelessWidget {
  /// Teks pesan yang ditampilkan di dalam bubble.
  final String message;

  /// Waktu pesan dikirim (format HH:mm).
  final String timestamp;

  const ChatAiBubble({
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
          /// Avatar robot AI (lingkaran hijau dengan ikon robot).
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
                /// Bubble pesan putih.
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
