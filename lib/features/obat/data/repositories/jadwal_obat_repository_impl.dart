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
    final model = JadwalObatModel.fromEntity(jadwal);
    await _datasource.saveJadwal(model);
  }

  @override
  Future<List<JadwalObat>> getAllJadwal() async {
    final models = await _datasource.getAllJadwal();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteJadwal(String id) async {
    await _datasource.deleteJadwal(id);
  }
}
