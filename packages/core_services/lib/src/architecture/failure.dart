/// [Failure] - Representasi error di level domain/presentation.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Error yang terjadi saat pemanggilan ke API/Server.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan pada server.']);
}

/// Error yang terjadi saat akses ke penyimpanan lokal.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal mengakses data lokal.']);
}

/// Error karena masalah koneksi internet.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Pastikan perangkat terhubung ke internet.']);
}
