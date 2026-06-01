/// [ServiceLocator] - Service locator sederhana untuk dependency injection.
///
/// Pola ini memungkinkan registrasi dan resolusi dependency secara global
/// tanpa perlu framework DI berat. Cocok untuk ukuran aplikasi saat ini.
///
/// Contoh penggunaan:
/// ```dart
/// // Registrasi di main.dart atau App startup
/// ServiceLocator.instance.register<ObatRepository>(ObatRepository.instance);
///
/// // Resolusi di mana saja
/// final repo = ServiceLocator.instance.get<ObatRepository>();
/// ```
class ServiceLocator {
  // ── Singleton ──────────────────────────────────────────────
  static final ServiceLocator instance = ServiceLocator._();
  ServiceLocator._();

  // ── Storage ────────────────────────────────────────────────
  final Map<Type, dynamic> _services = {};

  // ── Public API ─────────────────────────────────────────────

  /// Daftarkan dependency dengan tipe [T].
  void register<T>(T service) {
    _services[T] = service;
  }

  /// Dapatkan dependency terdaftar berdasarkan tipe [T].
  /// Melempar [StateError] jika belum terdaftar.
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw StateError(
        'Service of type $T is not registered. '
        'Did you forget to call register<T>()?',
      );
    }
    return service as T;
  }

  /// Hapus semua registrasi (berguna untuk testing).
  void clear() {
    _services.clear();
  }
}
