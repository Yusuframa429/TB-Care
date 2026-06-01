import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ChatHeader] - Header putih untuk halaman Chat.
///
/// Menampilkan judul dan subtitle yang berubah secara dinamis
/// berdasarkan mode yang sedang aktif (AI atau Dokter).
///
/// Parameter:
/// - [isAiMode]: `true` jika Mode AI aktif, `false` jika Chat Dokter.
class ChatHeader extends StatelessWidget {
  /// `true` = Mode AI, `false` = Chat Dokter.
  final bool isAiMode;

  const ChatHeader({super.key, required this.isAiMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: Row(
            children: [
              if (Navigator.canPop(context))
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),

              /// Judul dan subtitle.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAiMode ? 'AI Asisten TBC' : 'Konsultasi Dokter',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        /// Dot indikator online (hijau).
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isAiMode ? 'Aktif 24/7' : 'Dokter Online',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
