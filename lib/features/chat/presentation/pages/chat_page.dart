import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_services/core_services.dart';

import '../../data/dokter_data.dart';

import '../widgets/chat_header.dart';
import '../widgets/chat_mode_toggle.dart';
import '../widgets/chat_ai_bubble.dart';
import '../widgets/chat_user_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_typing_indicator.dart';
import '../widgets/dokter_card.dart';

/// Model data untuk satu pesan dalam chat.
class _ChatMessage {
  /// `true` jika pesan dari AI, `false` jika dari user.
  final bool isAi;

  /// Isi teks pesan.
  final String text;

  /// Waktu pesan dikirim (format "HH:mm").
  final String timestamp;

  _ChatMessage({
    required this.isAi,
    required this.text,
    required this.timestamp,
  });
}

/// [ChatPage] - Halaman fitur chat dengan 2 mode:
///
/// 1. **Mode AI**: Chatbot interaktif menggunakan Google Gemini API
///    untuk menjawab pertanyaan seputar TBC, pengobatan, dan pencegahan.
///    Dilengkapi quick reply chips dan input teks manual.
///
/// 2. **Chat Dokter**: Daftar dokter spesialis paru/TBC yang tersedia
///    untuk konsultasi via WhatsApp.
///
/// Halaman ini adalah tab utama di bottom navbar (indeks 2),
/// sehingga tidak memiliki tombol back arrow.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ── State ──────────────────────────────────────────────────

  /// `true` = Mode AI aktif, `false` = Chat Dokter aktif.
  bool _isAiMode = true;

  /// Riwayat pesan chat AI.
  final List<_ChatMessage> _messages = [];

  /// Controller untuk input field.
  final TextEditingController _textController = TextEditingController();

  /// Controller untuk auto-scroll ke pesan terbaru.
  final ScrollController _scrollController = ScrollController();

  /// Service AI Client.
  final AIClient _aiClient = AIClient.instance;

  /// Apakah AI sedang memproses respons.
  bool _isTyping = false;

  // ── Lifecycle ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Tambahkan pesan sambutan AI saat pertama kali dibuka.
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Welcome Message ────────────────────────────────────────

  /// Menambahkan pesan sambutan otomatis dari AI.
  void _addWelcomeMessage() {
    _messages.add(_ChatMessage(
      isAi: true,
      text: 'Halo! Saya asisten AI kesehatan TBC. '
          'Saya siap membantu menjawab pertanyaan seputar TBC, '
          'pengobatan, dan pencegahannya. '
          'Ada yang bisa saya bantu?',
      timestamp: _currentTime(),
    ));
  }

  // ── Chat Actions ───────────────────────────────────────────

  /// Kirim pesan dari user dan dapatkan respons dari Gemini AI.
  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isTyping) return;

    // Tambahkan pesan user ke chat.
    setState(() {
      _messages.add(_ChatMessage(
        isAi: false,
        text: trimmed,
        timestamp: _currentTime(),
      ));
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Kirim ke AI dan tunggu respons.
    final response = await _aiClient.sendMessage(trimmed);

    if (!mounted) return;

    setState(() {
      _messages.add(_ChatMessage(
        isAi: true,
        text: response,
        timestamp: _currentTime(),
      ));
      _isTyping = false;
    });

    _scrollToBottom();
  }

  /// Handler saat user menekan tombol send.
  void _onSend() {
    _sendMessage(_textController.text);
  }

  /// Handler saat user menekan quick reply chip.
  void _onQuickReply(String text) {
    _sendMessage(text);
  }

  // ── Helpers ────────────────────────────────────────────────

  /// Mendapatkan waktu saat ini dalam format "HH:mm".
  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  /// Scroll ke pesan terbaru di bawah.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          /// Header dinamis (judul berubah sesuai mode).
          ChatHeader(isAiMode: _isAiMode),

          /// Toggle pill Mode AI ↔ Chat Dokter.
          ChatModeToggle(
            isAiMode: _isAiMode,
            onModeChanged: (isAi) {
              setState(() => _isAiMode = isAi);
            },
          ),

          /// Konten utama sesuai mode.
          Expanded(
            child: _isAiMode ? _buildAiChatView() : _buildDokterView(),
          ),

          /// Input bar hanya tampil di Mode AI.
          if (_isAiMode)
            ChatInputBar(
              controller: _textController,
              onSend: _onSend,
              onQuickReply: _onQuickReply,
              // Quick replies hanya muncul saat baru 1 pesan (sambutan).
              showQuickReplies: _messages.length <= 1,
              isLoading: _isTyping,
            ),
        ],
      ),
    );
  }

  // ── Mode AI: Chat View ─────────────────────────────────────

  /// Membangun tampilan chat AI (daftar pesan + typing indicator).
  Widget _buildAiChatView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      // +1 untuk typing indicator (jika sedang mengetik).
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        // Item terakhir = typing indicator (jika sedang mengetik).
        if (_isTyping && index == _messages.length) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: ChatTypingIndicator(),
          );
        }

        final msg = _messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: msg.isAi
              ? ChatAiBubble(
                  message: msg.text,
                  timestamp: msg.timestamp,
                )
              : ChatUserBubble(
                  message: msg.text,
                  timestamp: msg.timestamp,
                ),
        );
      },
    );
  }

  // ── Mode Dokter: Daftar Dokter ─────────────────────────────

  /// Membangun tampilan daftar dokter untuk konsultasi WhatsApp.
  Widget _buildDokterView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label "Pilih Dokter".
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Pilih Dokter',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// Daftar kartu dokter.
          ...daftarDokter.map((dokter) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DokterCard(dokter: dokter),
            );
          }),
        ],
      ),
    );
  }
}

