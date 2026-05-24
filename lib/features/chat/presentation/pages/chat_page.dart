import 'package:flutter/material.dart';

import '../widgets/chat_header.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/quick_reply_chip.dart';
import '../widgets/chat_input_bar.dart';

/// [ChatPage] - Halaman Ngobrol Bareng AI.
///
/// Halaman ini menampilkan antarmuka chat dengan asisten AI TBC.
/// Terdiri dari:
/// - Header: profil AI + toggle mode (AI / Chat Dokter)
/// - Area chat: bubble pesan sambutan AI
/// - Quick reply: saran pertanyaan cepat
/// - Input bar: kolom ketik + tombol kirim
///
 /// Halaman ini ditempatkan di tab ke-2 (Chat) pada [MainShell]
/// dan tidak memiliki bottom navigation sendiri karena sudah
/// disediakan oleh [TbCareBottomNavbar].
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  /// Placeholder untuk tombol kirim / submit.
  void _onSendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    // TODO: Kirim pesan ke AI dan tampilkan respons.
    _inputController.clear();
  }

  /// Placeholder untuk quick reply chip.
  void _onQuickReply(String query) {
    // TODO: Kirim query ke AI dan tampilkan respons.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Header menggunakan PreferredSize agar tidak ikut di-scroll.
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(108),
        child: ChatHeader(),
      ),
      body: Column(
        children: [
          // Area chat — mengisi sisa ruang.
          Expanded(child: _buildChatArea()),

          // Saran pertanyaan cepat (horizontal scroll).
          _buildQuickReplies(),

          // Kolom input pesan.
          ChatInputBar(
            controller: _inputController,
            onSend: _onSendMessage,
          ),
        ],
      ),
    );
  }

  /// Area percakapan yang berisi bubble chat AI.
  Widget _buildChatArea() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      children: [
        ChatBubble(
          message:
              'Halo! Saya asisten AI kesehatan TBC. Saya siap membantu '
              'menjawab pertanyaan seputar TBC, pengobatan, dan '
              'pencegahannya. Ada yang bisa saya bantu?',
          timestamp: '14:02',
        ),
      ],
    );
  }

  /// Baris saran pertanyaan cepat dalam [SingleChildScrollView] horizontal.
  Widget _buildQuickReplies() {
    final queries = [
      'Apa itu TBC?',
      'Cara pencegahan TBC',
      'Jadwal minum obat',
      'Efek samping obat',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.8, horizontal: 16),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.80, color: Color(0xFFF1F5F9)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: queries.map((q) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: QuickReplyChip(
                label: q,
                onTap: () => _onQuickReply(q),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

