import 'result.dart';

/// [BaseUseCase] - Blueprint untuk semua Use Case di aplikasi.
///
/// [T] adalah tipe data yang dikembalikan.
/// [P] adalah parameter input yang dibutuhkan (bisa berupa Class Params).
abstract class BaseUseCase<T, P> {
  Future<Result<T>> call(P params);
}

/// Digunakan jika Use Case tidak membutuhkan parameter.
class NoParams {
  const NoParams();
}
