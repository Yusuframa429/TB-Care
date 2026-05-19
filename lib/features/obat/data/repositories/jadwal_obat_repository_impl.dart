import '../../domain/entities/jadwal_obat.dart';
import '../../domain/repositories/jadwal_obat_repository.dart';
import '../datasources/obat_local_datasource.dart';
import '../models/jadwal_obat_model.dart';

/// [JadwalObatRepositoryImpl] - Implementasi konkret dari [JadwalObatRepository].
///
/// Menjembatani domain layer dengan data layer (datasource Hive).
/// Domain layer hanya berinteraksi dengan interface [JadwalObatRepository],
/// tidak mengenal class ini secara langsung.
class JadwalObatRepositoryImpl implements JadwalObatRepository {
  final ObatLocalDatasource _datasource;

  JadwalObatRepositoryImpl(this._datasource);

  @override
  Future<void> saveJadwal(JadwalObat jadwal) async {
    // TODO: Implementasikan dengan Hive jika akan digunakan.
    // Tim saat ini menggunakan ObatRepository dengan SharedPreferences.
  }

  @override
  Future<List<JadwalObat>> getAllJadwal() async {
    // TODO: Implementasikan dengan Hive jika akan digunakan.
    return [];
  }

  @override
  Future<void> deleteJadwal(String id) async {
    // TODO: Implementasikan dengan Hive jika akan digunakan.
  }
}
