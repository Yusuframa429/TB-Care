# TB Care

Aplikasi Flutter untuk pemantauan dan kepedulian Tuberkulosis (TB). Proyek ini dibangun menggunakan arsitektur **Modular / Monorepo** agar kode lebih rapi, terukur, dan mudah dikolaborasikan oleh tim.

## 📦 Struktur Proyek (Monorepo)

Proyek ini menggunakan **Melos** dan fitur bawaan *Dart Workspaces* untuk mengelola multi-package. Struktur utamanya meliputi:

- `/` (Root): Aplikasi utama `tb_care` yang menyatukan semua fitur.
- `/packages/core_ui`: Package khusus untuk komponen UI visual (tombol, input, warna, tema) yang dapat digunakan ulang.
- `/packages/core_services`: Package khusus untuk logika bisnis, integrasi API, database lokal, dan layanan lainnya.

## 🚀 Panduan Memulai (Getting Started)

Karena proyek ini dikonfigurasi dengan FVM (Flutter Version Management) dan Melos, ikuti langkah berikut untuk setup di komputer Anda:

### 1. Prasyarat
Pastikan Anda sudah menginstal alat berikut di komputer Anda:
- [FVM](https://fvm.app/docs/getting_started/installation) untuk manajemen versi Flutter.

### 2. Setup & Sinkronisasi
Buka terminal di dalam folder proyek ini, lalu jalankan perintah berikut:

```bash
# 1. Unduh/gunakan versi Flutter yang sesuai dengan konfigurasi tim
fvm install
fvm use

# 2. Sinkronisasikan semua dependensi package di seluruh workspace
fvm flutter pub get
fvm dart run melos bs
```

### 3. Jalankan Aplikasi
Setelah proses sinkronisasi (bootstrap) selesai, Anda dapat menjalankan aplikasi seperti biasa:

```bash
fvm flutter run
```

## 📝 Aturan Kontribusi & Changelog

Tim proyek ini dianjurkan menggunakan format **Conventional Commits** setiap kali melakukan perubahan (contoh: `feat: tambah halaman login`, `fix: perbaiki tombol error`, `docs: perbarui readme`).

Hal ini bertujuan agar ke depannya Melos dapat men-generate dokumentasi `CHANGELOG.md` secara otomatis setiap kali ada rilis versi baru.
