import 'package:flutter_dotenv/flutter_dotenv.dart';

/// [EnvService] - Service untuk mengelola variabel lingkungan (.env).
class EnvService {
  static final EnvService instance = EnvService._();
  EnvService._();

  /// Memuat file .env.
  Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  /// Mendapatkan value berdasarkan key.
  String get(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Helper khusus untuk Gemini API Key.
  String get geminiApiKey => get('GEMINI_API_KEY');

  /// Helper khusus untuk DeepSeek API Key.
  String get deepseekApiKey => get('DEEPSEEK_API_KEY');
}
