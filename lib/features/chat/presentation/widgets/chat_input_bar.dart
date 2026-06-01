import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ChatInputBar] - Widget input pesan dengan quick reply chips.
///
/// Menampilkan:
/// - Quick reply chips horizontal (opsional, hanya muncul di awal chat)
/// - TextField "Ketik pertanyaan Anda..." dengan tombol send
///
/// Parameter:
/// - [controller]: TextEditingController untuk input field.
/// - [onSend]: Callback saat user menekan tombol send.
/// - [onQuickReply]: Callback saat user menekan salah satu chip.
/// - [showQuickReplies]: Apakah quick reply chips ditampilkan.
/// - [isLoading]: Apakah AI sedang memproses (disable input saat loading).
class ChatInputBar extends StatelessWidget {
  /// Controller untuk mengelola teks di input field.
  final TextEditingController controller;

  /// Callback saat user menekan tombol send (ikon paper plane).
  final VoidCallback onSend;

  /// Callback saat user menekan salah satu quick reply chip.
  final ValueChanged<String> onQuickReply;

  /// Apakah quick reply chips ditampilkan.
  final bool showQuickReplies;

  /// Apakah input sedang dalam mode loading (disable send).
  final bool isLoading;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onQuickReply,
    this.showQuickReplies = true,
    this.isLoading = false,
  });

  /// Daftar quick reply yang tersedia.
  static const List<String> _quickReplies = [
    'Apa itu TBC?',
    'Cara pencegahan TBC',
    'Jadwal minum obat',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Quick reply chips (hanya tampil saat [showQuickReplies] = true).
            if (showQuickReplies) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _quickReplies.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final text = _quickReplies[index];
                    return _buildChip(text);
                  },
                ),
              ),
            ],
            const SizedBox(height: 10),

            /// Input field dan tombol send.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  /// TextField.
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: controller,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => onSend(),
                        decoration: InputDecoration(
                          hintText: 'Ketik pertanyaan Anda...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  /// Tombol send (ikon paper plane).
                  GestureDetector(
                    onTap: isLoading ? null : onSend,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isLoading
                            ? AppColors.textSecondary.withValues(alpha: 0.3)
                            : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun satu quick reply chip.
  Widget _buildChip(String text) {
    return GestureDetector(
      onTap: isLoading ? null : () => onQuickReply(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
