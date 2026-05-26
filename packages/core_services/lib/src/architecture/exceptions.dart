/// [ServerException] - Dilemparkan saat terjadi error di level data source (API).
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server Error']);
}

/// [CacheException] - Dilemparkan saat terjadi error di level data source (Local Storage).
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache Error']);
}
