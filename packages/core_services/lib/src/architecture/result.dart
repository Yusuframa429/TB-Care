import 'failure.dart';

/// [Result] - Wrapper untuk menangani balikan sukses atau gagal secara elegan.
///
/// Penggunaan:
/// ```dart
/// final result = await repository.getData();
/// if (result.isSuccess) {
///   print(result.value);
/// } else {
///   print(result.failure);
/// }
/// ```
class Result<T> {
  final T? _value;
  final Failure? _failure;

  Result._(this._value, this._failure);

  /// Membuat instance [Result] sukses.
  factory Result.success(T value) => Result._(value, null);

  /// Membuat instance [Result] gagal.
  factory Result.failure(Failure failure) => Result._(null, failure);

  /// Apakah operasi berhasil?
  bool get isSuccess => _failure == null;

  /// Apakah operasi gagal?
  bool get isFailure => _failure != null;

  /// Mendapatkan nilai jika sukses.
  /// Hati-hati: akan melempar error jika dipanggil saat status gagal.
  T get value {
    if (isFailure) {
      throw StateError('Cannot get value from a failure result. Use failure instead.');
    }
    return _value as T;
  }

  /// Mendapatkan objek [Failure] jika gagal.
  Failure get failure {
    if (isSuccess) {
      throw StateError('Cannot get failure from a success result. Use value instead.');
    }
    return _failure!;
  }
}
