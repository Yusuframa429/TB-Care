import 'package:flutter/material.dart';

/// [ChatInputBar] - Kolom input pesan dengan tombol kirim.
///
/// Menampilkan [TextField] dengan styling pill dan tombol
/// kirim di samping kanan. Cocok ditempatkan di bagian bawah
/// halaman chat.
class ChatInputBar extends StatelessWidget {
  /// [TextEditingController] untuk mengontrol input teks.
  final TextEditingController controller;

  /// Callback saat tombol kirim ditekan.
  final VoidCallback? onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          // Field input teks
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                color: const Color(0xFFF8FAFC),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.80, color: Color(0xFFE2E8F0)),
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                ),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Ketik pertanyaan Anda...',
                  hintStyle: TextStyle(
                    color: Color(0xFF90A1B9),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1D293D),
                ),
                onSubmitted: (_) => onSend?.call(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Tombol kirim
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: const ShapeDecoration(
                color: Color(0xFFE2E8F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
              ),
              child: const Icon(
                Icons.send,
                color: Color(0xFF94A3B8),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
