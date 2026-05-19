import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../data/artikel_data.dart';
import '../../domain/entities/artikel.dart';

/// [EdukasiListPage] - Halaman daftar lengkap artikel Edukasi & Update.
///
/// Fitur:
/// - Search bar untuk filter artikel berdasarkan judul/deskripsi.
/// - Filter chip kategori (otomatis dari data, bisa ditambah fleksibel).
/// - Badge "Baru" otomatis untuk artikel ≤ 7 hari terakhir.
/// - Tap artikel membuka link di browser eksternal.
class EdukasiListPage extends StatefulWidget {
  const EdukasiListPage({super.key});

  @override
  State<EdukasiListPage> createState() => _EdukasiListPageState();
}

class _EdukasiListPageState extends State<EdukasiListPage> {
  String _selectedKategori = 'Semua';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// Daftar kategori unik dari data, diawali "Semua".
  List<String> get _kategoriList {
    final categories = artikelList.map((a) => a.kategori).toSet().toList();
    categories.sort();
    return ['Semua', ...categories];
  }

  /// Artikel yang sudah difilter berdasarkan kategori dan pencarian.
  List<Artikel> get _filteredArtikel {
    var list = List<Artikel>.from(artikelList);

    // Filter kategori.
    if (_selectedKategori != 'Semua') {
      list = list.where((a) => a.kategori == _selectedKategori).toList();
    }

    // Filter pencarian.
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list
          .where((a) =>
              a.judul.toLowerCase().contains(query) ||
              a.deskripsi.toLowerCase().contains(query) ||
              a.kategori.toLowerCase().contains(query))
          .toList();
    }

    // Urutkan terbaru dulu.
    list.sort((a, b) => b.tanggalPublikasi.compareTo(a.tanggalPublikasi));
    return list;
  }

  /// Membuka link artikel di browser eksternal.
  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredArtikel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edukasi & Update',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          /// Search bar.
          _buildSearchBar(),
          const SizedBox(height: 14),

          /// Filter chips kategori.
          _buildFilterChips(),
          const SizedBox(height: 18),

          /// Label "TERBARU".
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text('📰', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  'TERBARU',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          /// Daftar artikel.
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _ArtikelListCard(
                        artikel: filtered[index],
                        onTap: () => _openLink(filtered[index].linkArtikel),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Search bar widget.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Cari artikel...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  /// Filter chips kategori (scrollable horizontal).
  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _kategoriList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final kategori = _kategoriList[index];
          final isSelected = _selectedKategori == kategori;

          return GestureDetector(
            onTap: () => setState(() => _selectedKategori = kategori),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                kategori,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// State kosong jika tidak ada artikel yang cocok.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📭', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Tidak ada artikel ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coba ubah kata kunci atau filter kategori',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Widget kartu artikel untuk list
// ─────────────────────────────────────────────────────────────────

/// [_ArtikelListCard] - Kartu artikel vertikal dengan gambar, badge, dan info.
class _ArtikelListCard extends StatelessWidget {
  final Artikel artikel;
  final VoidCallback onTap;

  const _ArtikelListCard({
    required this.artikel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = kategoriStyles[artikel.kategori];
    final dateStr = DateFormat('d MMM yyyy', 'id_ID').format(artikel.tanggalPublikasi);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Gambar artikel dengan badge overlay.
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  // Gambar dari URL.
                  Image.network(
                    artikel.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 180,
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stack) {
                      return Container(
                        height: 180,
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 40, color: AppColors.textSecondary),
                        ),
                      );
                    },
                  ),

                  // Badge "Baru" (top-left).
                  if (artikel.isNew)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 6, color: Color(0xFF4ADE80)),
                            SizedBox(width: 5),
                            Text(
                              'Baru',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Badge kategori (top-right).
                  if (style != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: style.bgColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          artikel.kategori,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: style.color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Konten teks di bawah gambar.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul.
                  Text(
                    artikel.judul,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Deskripsi.
                  Text(
                    artikel.deskripsi,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Tanggal & durasi baca.
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 13,
                          color: AppColors.textSecondary.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.schedule,
                          size: 13,
                          color: AppColors.textSecondary.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        '${artikel.waktuBacaMenit} menit',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
