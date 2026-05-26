import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/env_service.dart';
import '../services/logger_service.dart';

/// [AIClient] - Service untuk integrasi DeepSeek API yang terpusat.
class AIClient {
  static final AIClient instance = AIClient._();
  AIClient._();

  /// Menyimpan riwayat percakapan untuk konteks chat.
  final List<Map<String, String>> _messages = [];

  static const String _systemPrompt = '''
Kamu adalah asisten AI kesehatan bernama "AI Asisten TBC" di aplikasi TB Care.

Peranmu:
- Menjawab pertanyaan seputar Tuberkulosis (TBC), pengobatan, pencegahan, dan gejala.
- Memberikan informasi edukasi kesehatan paru-paru yang akurat dan mudah dipahami.
- Mengingatkan pengguna bahwa kamu bukan pengganti dokter dan menyarankan konsultasi ke tenaga medis untuk diagnosis.
- Menjawab dalam Bahasa Indonesia yang sopan dan ramah.
- Menjawab dengan ringkas namun informatif.
- Jika ditanya di luar topik kesehatan/TBC, arahkan kembali ke topik TBC dengan sopan.

Jangan:
- Memberikan diagnosis medis.
- Meresepkan obat tanpa saran dokter.
''';

  /// Mengirim pesan ke DeepSeek API dan mendapatkan respon.
  Future<String> sendMessage(String message) async {
    try {
      final apiKey = EnvService.instance.deepseekApiKey;
      if (apiKey.isEmpty) {
        LoggerService.e('DeepSeek API Key is missing in .env');
        return 'Maaf, API Key DeepSeek belum dikonfigurasi di file .env.';
      }

      // Inisialisasi system prompt jika percakapan baru dimulai
      if (_messages.isEmpty) {
        _messages.add({'role': 'system', 'content': _systemPrompt});
      }

      // Tambahkan pesan user ke riwayat
      _messages.add({'role': 'user', 'content': message});

      final response = await http.post(
        Uri.parse('https://api.deepseek.com/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': _messages,
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['choices'][0]['message']['content'] as String;

        // Tambahkan respon AI ke riwayat
        _messages.add({'role': 'assistant', 'content': reply});
        return reply;
      } else {
        LoggerService.e('DeepSeek Error: ${response.statusCode} - ${response.body}');
        // Hapus pesan user terakhir agar tidak mengotori riwayat
        if (_messages.isNotEmpty && _messages.last['role'] == 'user') {
          _messages.removeLast();
        }
        return 'Maaf, terjadi kesalahan saat menghubungi layanan AI DeepSeek (Status: ${response.statusCode}).';
      }
    } catch (e) {
      LoggerService.e('AI Error: $e');
      // Hapus pesan user terakhir agar tidak mengotori riwayat
      if (_messages.isNotEmpty && _messages.last['role'] == 'user') {
        _messages.removeLast();
      }
      return 'Maaf, terjadi kesalahan atau timeout pada koneksi layanan AI.';
    }
  }

  /// Reset percakapan.
  void resetChat() {
    _messages.clear();
  }
}
