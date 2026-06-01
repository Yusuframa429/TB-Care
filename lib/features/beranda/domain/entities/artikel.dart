/// [Artikel] - Entity yang merepresentasikan satu artikel edukasi/berita.
///
/// Digunakan untuk menampilkan daftar artikel di halaman Edukasi & Update.
/// Developer cukup menambahkan data baru di [artikel_data.dart].
class Artikel {
  /// Judul artikel yang ditampilkan di kartu.
  final String judul;

  /// Deskripsi singkat / ringkasan artikel (1-2 kalimat).
  final String deskripsi;

  /// URL gambar thumbnail dari internet (network image).
  final String imageUrl;

  /// Kategori artikel (misal: "Pencegahan", "Nutrisi", "Gaya Hidup", "Obat").
  /// Kategori baru otomatis muncul di filter chip.
  final String kategori;

  /// URL artikel lengkap yang akan dibuka di browser saat user menekan kartu.
  final String linkArtikel;

  /// Tanggal publikasi artikel.
  final DateTime tanggalPublikasi;

  /// Estimasi waktu baca dalam menit.
  final int waktuBacaMenit;

  Artikel({
    required this.judul,
    required this.deskripsi,
    required this.imageUrl,
    required this.kategori,
    required this.linkArtikel,
    required this.tanggalPublikasi,
    required this.waktuBacaMenit,
  });

  /// Mengembalikan `true` jika artikel dipublikasikan dalam 7 hari terakhir.
  /// Badge "Baru" akan otomatis muncul pada kartu artikel.
  bool get isNew => DateTime.now().difference(tanggalPublikasi).inDays <= 7;
}
