import 'package:flutter/material.dart';

/// [ChatBubble] - Bubble chat untuk pesan dari AI.
///
/// Menampilkan pesan teks dalam balon chat dengan sudut melengkung
/// khas (tajam di kiri atas, bulat di sisi lain), shadow halus,
/// dan timestamp di bawahnya.
///
/// Tidak menangani bubble user karena halaman ini hanya menampilkan
/// pesan sambutan AI (belum ada input dari user).
class ChatBubble extends StatelessWidget {
  /// Teks pesan yang akan ditampilkan.
  final String message;

  /// Waktu pengiriman pesan (format "HH:mm").
  final String timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar AI (gradient hijau)
        Container(
          width: 32,
          height: 32,
          decoration: const ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.00),
              end: Alignment(1.00, 1.00),
              colors: [Color(0xFF059669), Color(0xFF14B8A6)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(999)),
            ),
          ),
          child: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 8),
        // Bubble chat
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.63,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  timestamp,
                  style: const TextStyle(
                    color: Color(0xFF90A1B9),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
