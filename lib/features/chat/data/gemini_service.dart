import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// [GeminiService] - Service singleton untuk integrasi Google Gemini API.
///
/// Menyediakan koneksi ke Gemini AI dengan system prompt yang terfokus
/// pada domain kesehatan Tuberkulosis (TBC). Menggunakan chat session
/// agar konteks percakapan multi-turn tetap terjaga.
///
/// ## Setup
/// Ganti [_apiKey] dengan API key Anda dari
/// [Google AI Studio](https://aistudio.google.com/apikey).
///
/// ## Contoh penggunaan:
/// ```dart
/// final service = GeminiService.instance;
/// final response = await service.sendMessage('Apa itu TBC?');
/// ```
class GeminiService {
  // ── Singleton ──────────────────────────────────────────────
  static final GeminiService instance = GeminiService._();
  GeminiService._();

  // ── Konfigurasi ────────────────────────────────────────────

  /// API Key Google Gemini yang dimuat secara dinamis dari file .env.
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  /// System instruction agar AI fokus pada domain TBC/kesehatan paru.
  static const String _systemPrompt = '''
Kamu adalah asisten AI kesehatan bernama "AI Asisten TBC" di aplikasi TB Care.

Peranmu:
- Menjawab pertanyaan seputar Tuberkulosis (TBC), pengobatan, pencegahan, dan gejala.
- Memberikan informasi edukasi kesehatan paru-paru yang akurat dan mudah dipahami.
- Mengingatkan pengguna bahwa kamu bukan pengganti dokter dan menyarankan konsultasi ke tenaga medis untuk diagnosis.
- Menjawab dalam Bahasa Indonesia yang sopan dan ramah.
- Menjawab dengan ringkas namun informatif (maksimal 3-4 paragraf pendek).
- Jika ditanya di luar topik kesehatan/TBC, arahkan kembali ke topik TBC dengan sopan.

Jangan:
- Memberikan diagnosis medis.
- Meresepkan obat tanpa saran dokter.
- Menjawab topik yang tidak berhubungan dengan kesehatan.
''';

  // ── State ──────────────────────────────────────────────────

  GenerativeModel? _model;
  ChatSession? _chatSession;

  // ── Initialization ─────────────────────────────────────────

  /// Inisialisasi model Gemini dan buat chat session baru.
  /// Dipanggil secara lazy saat pertama kali [sendMessage] digunakan.
  void _ensureInitialized() {
    if (_model != null) return;

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );

    _chatSession = _model!.startChat();
  }

  // ── Public API ─────────────────────────────────────────────

  /// Kirim pesan ke Gemini dan terima respons teks.
  ///
  /// Mengembalikan [String] berisi respons dari AI.
  /// Jika terjadi error, mengembalikan pesan error yang ramah pengguna.
  Future<String> sendMessage(String message) async {
    try {
      _ensureInitialized();

      final response = await _chatSession!.sendMessage(
        Content.text(message),
      );

      return response.text ??
          'Maaf, saya tidak bisa memproses permintaan Anda saat ini. Silakan coba lagi.';
    } catch (e) {
      if (e.toString().contains('API_KEY')) {
        return 'API Key belum dikonfigurasi. Silakan masukkan API key Gemini Anda di file gemini_service.dart.';
      }
      return 'Maaf, terjadi kesalahan koneksi. Pastikan Anda terhubung ke internet dan coba lagi.\n\nDetail: ${e.toString()}';
    }
  }

  /// Reset chat session (mulai percakapan baru).
  void resetChat() {
    _chatSession = _model?.startChat();
  }

  /// Cek apakah API key sudah dikonfigurasi dan valid.
  bool get isApiKeyConfigured => _apiKey.isNotEmpty && _apiKey != 'YOUR_GEMINI_API_KEY';
}
