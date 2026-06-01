/// [ChatMessage] - Entity yang merepresentasikan satu pesan dalam chat.
///
/// Digunakan untuk menyimpan riwayat percakapan antara user dan AI.
class ChatMessage {
  /// ID unik pesan (epoch milliseconds).
  final String id;

  /// Isi teks pesan.
  final String text;

  /// true = pesan dari AI, false = pesan dari user.
  final bool isAi;

  /// Waktu pengiriman pesan dalam format "HH:mm".
  final String timestamp;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isAi,
    this.timestamp = '',
  });
}
