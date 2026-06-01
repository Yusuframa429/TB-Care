import '../../domain/entities/jadwal_obat.dart';
import '../../domain/repositories/jadwal_obat_repository.dart';
import '../obat_repository.dart';

/// [JadwalObatRepositoryImpl] - Implementasi konkret dari [JadwalObatRepository].
///
/// Menjembatani domain layer dengan data layer (datasource Hive).
/// Domain layer hanya berinteraksi dengan interface [JadwalObatRepository],
/// tidak mengenal class ini secara langsung.
class JadwalObatRepositoryImpl implements JadwalObatRepository {
  JadwalObatRepositoryImpl();

  @override
  Future<void> saveJadwal(JadwalObat jadwal) async {
    await ObatRepository.instance.init();
    await ObatRepository.instance.simpanJadwal(jadwal);
  }

  @override
  Future<List<JadwalObat>> getAllJadwal() async {
    await ObatRepository.instance.init();
    return ObatRepository.instance.getJadwalList();
  }

  @override
  Future<void> deleteJadwal(String id) async {
    await ObatRepository.instance.init();
    await ObatRepository.instance.hapusJadwal(id);
  }
}
