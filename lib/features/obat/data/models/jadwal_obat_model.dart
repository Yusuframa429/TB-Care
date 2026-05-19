import '../../domain/entities/jadwal_obat.dart';

/// [JadwalObatModel] - Model data layer untuk jadwal obat.
///
/// Bertanggung jawab mengkonversi antara [JadwalObat] (entity domain)
/// dan [Map<String, dynamic>] untuk keperluan penyimpanan lokal.
class JadwalObatModel {
  final String id;
  final String namaObat;
  final int jumlahDosis;
  final String satuanDosis;
  final List<String> waktuMinum;
  final String kondisiMakan;
  final String? frekuensi;
  final String? catatan;

  const JadwalObatModel({
    required this.id,
    required this.namaObat,
    required this.jumlahDosis,
    required this.satuanDosis,
    required this.waktuMinum,
    required this.kondisiMakan,
    this.frekuensi,
    this.catatan,
  });

  factory JadwalObatModel.fromEntity(JadwalObat entity) => JadwalObatModel(
        id: entity.id,
        namaObat: entity.namaObat,
        jumlahDosis: entity.jumlahDosis,
        satuanDosis: entity.satuanDosis,
        waktuMinum: entity.waktuMinum,
        kondisiMakan: entity.kondisiMakan,
        frekuensi: entity.frekuensi,
        catatan: entity.catatan,
      );

  factory JadwalObatModel.fromMap(Map<dynamic, dynamic> map) => JadwalObatModel(
        id: map['id'] as String,
        namaObat: map['namaObat'] as String,
        jumlahDosis: (map['jumlahDosis'] as num).toInt(),
        satuanDosis: map['satuanDosis'] as String,
        waktuMinum: List<String>.from(map['waktuMinum'] as List),
        kondisiMakan: map['kondisiMakan'] as String,
        frekuensi: map['frekuensi'] as String?,
        catatan: map['catatan'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'namaObat': namaObat,
        'jumlahDosis': jumlahDosis,
        'satuanDosis': satuanDosis,
        'waktuMinum': waktuMinum,
        'kondisiMakan': kondisiMakan,
        'frekuensi': frekuensi,
        'catatan': catatan,
      };

  JadwalObat toEntity() => JadwalObat(
        id: id,
        namaObat: namaObat,
        jumlahDosis: jumlahDosis,
        satuanDosis: satuanDosis,
        waktuMinum: waktuMinum,
        kondisiMakan: kondisiMakan,
        frekuensi: frekuensi,
        catatan: catatan,
      );
}
