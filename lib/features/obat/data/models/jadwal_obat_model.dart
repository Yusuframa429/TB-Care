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
  final bool isNotifikasiAktif;
  final bool isGetar;
  final bool isSuara;

  const JadwalObatModel({
    required this.id,
    required this.namaObat,
    required this.jumlahDosis,
    required this.satuanDosis,
    required this.waktuMinum,
    required this.kondisiMakan,
    this.frekuensi,
    this.catatan,
    this.isNotifikasiAktif = true,
    this.isGetar = true,
    this.isSuara = false,
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
        isNotifikasiAktif: entity.isNotifikasiAktif,
        isGetar: entity.isGetar,
        isSuara: entity.isSuara,
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
        isNotifikasiAktif: map['isNotifikasiAktif'] as bool? ?? true,
        isGetar: map['isGetar'] as bool? ?? true,
        isSuara: map['isSuara'] as bool? ?? false,
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
        'isNotifikasiAktif': isNotifikasiAktif,
        'isGetar': isGetar,
        'isSuara': isSuara,
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
        isNotifikasiAktif: isNotifikasiAktif,
        isGetar: isGetar,
        isSuara: isSuara,
      );
}
