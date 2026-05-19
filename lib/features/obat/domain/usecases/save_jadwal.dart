import '../entities/jadwal_obat.dart';
import '../repositories/jadwal_obat_repository.dart';

/// [SaveJadwal] - Use case untuk menyimpan jadwal obat baru.
class SaveJadwal {
  final JadwalObatRepository _repository;

  SaveJadwal(this._repository);

  Future<void> call(JadwalObat jadwal) {
    return _repository.saveJadwal(jadwal);
  }
}
