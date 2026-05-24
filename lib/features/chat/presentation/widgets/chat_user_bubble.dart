import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ChatUserBubble] - Bubble chat pesan dari pengguna.
///
/// Menampilkan bubble pesan di sisi kanan dengan warna hijau muda
/// dan timestamp di bawahnya.
///
/// Parameter:
/// - [message]: Teks pesan pengguna.
/// - [timestamp]: Waktu pesan dikirim (misal: "14:05").
class ChatUserBubble extends StatelessWidget {
  /// Teks pesan yang ditampilkan.
  final String message;

  /// Waktu pesan dikirim (format HH:mm).
  final String timestamp;

  const ChatUserBubble({
    super.key,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Bubble pesan user (hijau muda, rata kanan).
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(4),
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
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// Timestamp.
          Padding(
            padding: const EdgeInsets.only(right: 4),
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
    );
  }
}
