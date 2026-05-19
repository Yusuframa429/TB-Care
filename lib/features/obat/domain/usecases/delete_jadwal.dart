import '../repositories/jadwal_obat_repository.dart';

/// [DeleteJadwal] - Use case untuk menghapus jadwal obat.
class DeleteJadwal {
  final JadwalObatRepository _repository;

  DeleteJadwal(this._repository);

  Future<void> call(String id) {
    return _repository.deleteJadwal(id);
  }
}
