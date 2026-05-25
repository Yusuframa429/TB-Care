import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/env_service.dart';
import '../services/logger_service.dart';

/// [AIClient] - Service untuk integrasi Google Gemini API yang terpusat.
class AIClient {
  static final AIClient instance = AIClient._();
  AIClient._();

  GenerativeModel? _model;
  ChatSession? _chatSession;

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

  void _ensureInitialized() {
    if (_model != null) return;

    final apiKey = EnvService.instance.geminiApiKey;
    if (apiKey.isEmpty) {
      LoggerService.e('Gemini API Key is missing in .env');
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );

    _chatSession = _model!.startChat();
  }

  /// Mengirim pesan ke AI dan mendapatkan respon.
  Future<String> sendMessage(String message) async {
    try {
      _ensureInitialized();
      final response = await _chatSession!.sendMessage(Content.text(message));
      return response.text ?? 'Maaf, saya tidak bisa merespon saat ini.';
    } catch (e) {
      LoggerService.e('AI Error: $e');
      return 'Maaf, terjadi kesalahan pada layanan AI.';
    }
  }

  /// Reset percakapan.
  void resetChat() {
    _chatSession = _model?.startChat();
  }
}
