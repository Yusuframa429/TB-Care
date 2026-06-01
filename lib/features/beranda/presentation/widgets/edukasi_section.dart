import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/artikel_data.dart';
import '../../domain/entities/artikel.dart';

/// [EdukasiSection] - Section edukasi dan artikel di halaman Beranda.
///
/// Menampilkan 2 artikel terbaru dari [artikelList] secara horizontal.
/// Data diambil dinamis dari [artikel_data.dart] — bukan hardcode.
/// Tap kartu akan membuka link artikel di browser.
class EdukasiSection extends StatelessWidget {
  final VoidCallback? onSemuaArtikel;

  const EdukasiSection({super.key, this.onSemuaArtikel});

  /// Membuka link artikel di browser eksternal.
  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil 2 artikel terbaru, diurutkan dari yang paling baru.
    final sorted = List<Artikel>.from(artikelList)
      ..sort((a, b) => b.tanggalPublikasi.compareTo(a.tanggalPublikasi));
    final preview = sorted.take(2).toList();

    return Column(
      children: [
        SectionHeader(
          title: 'Edukasi & Update',
          emoji: '🔥',
          actionText: 'Semua Artikel',
          onActionTap: onSemuaArtikel,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (preview.isNotEmpty)
                Expanded(
                  child: _ArtikelPreviewCard(
                    artikel: preview[0],
                    onTap: () => _openLink(preview[0].linkArtikel),
                  ),
                ),
              if (preview.length > 1) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _ArtikelPreviewCard(
                    artikel: preview[1],
                    onTap: () => _openLink(preview[1].linkArtikel),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// [_ArtikelPreviewCard] - Kartu cuplikan artikel di beranda.
///
/// Menampilkan thumbnail gambar, badge kategori, judul, dan durasi baca.
/// Data diambil dari entity [Artikel].
class _ArtikelPreviewCard extends StatelessWidget {
  final Artikel artikel;
  final VoidCallback onTap;

  const _ArtikelPreviewCard({
    required this.artikel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = kategoriStyles[artikel.kategori];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Thumbnail gambar artikel dari URL.
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    artikel.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 100,
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stack) {
                      return Container(
                        height: 100,
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: Icon(Icons.image_outlined,
                              size: 28, color: AppColors.textSecondary),
                        ),
                      );
                    },
                  ),

                  /// Badge kategori (top-right).
                  if (style != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: style.bgColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          artikel.kategori,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: style.color,
                          ),
                        ),
                      ),
                    ),

                  /// Badge "Baru" (top-left).
                  if (artikel.isNew)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                size: 5, color: Color(0xFF4ADE80)),
                            SizedBox(width: 3),
                            Text(
                              'Baru',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// Konten teks di bawah gambar.
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Judul artikel.
                  Text(
                    artikel.judul,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  /// Durasi baca.
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${artikel.waktuBacaMenit} menit',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
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
