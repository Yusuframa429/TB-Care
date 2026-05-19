import '../entities/jadwal_obat.dart';
import '../repositories/jadwal_obat_repository.dart';

/// [GetAllJadwal] - Use case untuk mengambil semua jadwal obat.
class GetAllJadwal {
  final JadwalObatRepository _repository;

  GetAllJadwal(this._repository);

  Future<List<JadwalObat>> call() {
    return _repository.getAllJadwal();
  }
}
