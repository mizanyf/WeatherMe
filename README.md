# WeatherMe

<p align="center">
  <img src="assets/logo/WeatherMe.png" alt="WeatherMe Logo" width="130" style="border-radius: 28px; box-shadow: 0 8px 24px rgba(72, 203, 232, 0.3);" />
</p>

<p align="center">
  <strong>Aplikasi pemantau cuaca modern berbasis Flutter dengan estetika Blue Gradient Glassmorphism, integrasi Live Weather API, deteksi lokasi GPS otomatis, dan kalender cuaca interaktif.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge" alt="Platform" />
  <img src="https://img.shields.io/badge/Tests-20%20Passed-brightgreen?style=for-the-badge&logo=checkmarx&logoColor=white" alt="Tests" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License" />
</p>

---

## 📋 Daftar Isi

- [Gambaran Umum](#-gambaran-umum)
- [Fitur Utama](#-fitur-utama)
  - [1. Halaman Beranda (Home)](#1-halaman-beranda-home)
  - [2. Halaman Kalender Cuaca (Calendar)](#2-halaman-kalender-cuaca-calendar)
  - [3. Halaman Jelajahi Lokasi (Locations)](#3-halaman-jelajahi-lokasi-locations)
  - [4. Integrasi Live API & Geolokasi GPS](#4-integrasi-live-api--geolokasi-gps)
  - [5. Desain Sistem & Glassmorphism](#5-desain-sistem--glassmorphism)
- [Teknologi yang Digunakan](#-teknologi-yang-digunakan)
- [Struktur Direktori Proyek](#-struktur-direktori-proyek)
- [Persyaratan Sistem](#-persyaratan-sistem)
- [Panduan Instalasi & Menjalankan](#-panduan-instalasi--menjalankan)
- [Konfigurasi API Cuaca (.env)](#-konfigurasi-api-cuaca-env)
- [Pengujian Kualitas Kode (Testing)](#-pengujian-kualitas-kode-testing)
- [Kontribusi](#-kontribusi)
- [Lisensi](#-lisensi)
- [Pengembang](#-pengembang)

---

## 🌟 Gambaran Umum

**WeatherMe** adalah aplikasi pemantau cuaca lintas platform (*cross-platform*) yang dibangun dengan **Flutter** dan **Dart**. Aplikasi ini dirancang untuk memberikan pengalaman pemantauan cuaca yang informatif, akurat, dan memanjakan mata melalui implementasi antarmuka bergaya **Blue Gradient Glassmorphism**.

WeatherMe mendukung sinkronisasi data cuaca langsung (*live data*) dari penyedia layanan cuaca terkemuka seperti **WeatherAPI.com** dan **OpenWeatherMap**, dilengkapi dengan **Mode Demo Aman** (*Mock Fallback*) yang menjamin aplikasi tetap berjalan mulus meskipun tanpa koneksi internet atau API Key.

### 📱 Target Platform
- **Android** (Smartphone & Tablet)
- **iOS** (iPhone & iPad)
- **Web** (Desktop & Mobile Browser modern)

---

## 🚀 Fitur Utama

### 1. Halaman Beranda (*Home*)
- **Kartu Cuaca Utama (*Current Weather Hero Card*)**:
  - Menampilkan suhu terkini (°C), kondisi cuaca aktual, rentang suhu harian (Maks & Min), nama kota, serta waktu pembaruan terakhir.
  - Ilustrasi visual cuaca bertingkat (*layered native illustration*) yang dinamis dan proporsional.
  - Tombol segarkan cuaca sekali sentuh (*quick refresh*) dan badge status sumber data (*Live API* / *Mode Demo*).
- **Perkiraan Hari Ini (*Hourly Forecast*)**:
  - Barisan kartu horisontal yang responsif secara waktu nyata: menampilkan jam **Sekarang** diikuti jam-jam mendatang (pukul yang telah lewat disaring secara otomatis).
  - Tampilan kartu kaca bergradasi biru dengan ikon kondisi cuaca yang konsisten.
- **Perkiraan 3 Hari Mendatang**:
  - Ringkasan cepat perkiraan cuaca 3 hari ke depan dalam balutan kartu glassmorphism biru lengkap dengan bar rentang suhu.

### 2. Halaman Kalender Cuaca (*Calendar*)
- **Kalender Bulanan Interaktif (*Weather Calendar*)**:
  - Memilih tanggal tertentu untuk melihat proyeksi cuaca pada hari tersebut.
  - Penanda warna dan ikon cuaca pada tanggal kalender.
  - Pembatasan jendela prediksi cerdas: mendukung data hingga 7 hari ke belakang (dengan penanda kedaluwarsa) dan 7 hari ke depan (dengan penanda belum tersedia yang bersih tanpa *background noise*).
- **Kartu Perkiraan Hari Terpilih (*Selected Day Forecast Detail*)**:
  - Tampilan tanggal lengkap dengan tahun (contoh: *Hari ini, 22 Oktober 2026*).
  - Teks kondisi cuaca dengan warna netral elegan yang mudah dibaca.
  - Tampilan suhu dan rentang suhu maksimum/minimum yang proporsional.
  - 4 metrik cuaca mendalam: **Peluang Hujan**, **Kelembapan**, **Kecepatan Angin**, dan **Indeks UV**.
- **Perkiraan 7 Hari Mendatang (*Weekly Forecast List*)**:
  - Daftar rinci proyeksi cuaca selama satu pekan ke depan berdesain glass gradasi biru.

### 3. Halaman Jelajahi Lokasi (*Locations*)
- **Pencarian Kota Real-Time (*City Search Bar*)**:
  - Bilah input pencarian berdesain kaca gradasi biru dengan keterangan placeholder *"Cari kota atau negara..."*.
  - Pemfilteran instan untuk mencari kota tersimpan maupun kota baru.
- **Kartu Lokasi Saat Ini (*Current Location Card*)**:
  - Menampilkan data cuaca pada posisi koordinat perangkat saat ini.
  - Tombol aksi cepat **"Gunakan Lokasi Saya"** / **"Perbarui Lokasi"** dengan gradasi biru tema.
- **Daftar Kota Tersimpan (*Saved Cities*)**:
  - Kartu glassmorphism untuk setiap kota yang disimpan (misal: Jakarta, Tokyo, London, Sydney).
  - Mengetuk kartu kota akan langsung mengubahnya menjadi lokasi cuaca aktif.
- **Pop-Up Tambah Lokasi (*Add Location Bottom Sheet*)**:
  - Modal lembar bawah (*modal bottom sheet*) bergaya glassmorphism gradasi biru.
  - Menggunakan bilah pencarian `CitySearchBar` yang seragam.
  - Tombol cepat **"Gunakan Lokasi Saya"** yang ramping dan proporsional.
  - Katalog kota dengan ikon cuaca animasi dan tombol **"Tambah"** bergradasi biru.

### 4. Integrasi Live API & Geolokasi GPS
- **Dual-Mode Data Architecture**:
  - **Live API Mode**: Mengambil data cuaca riil dari WeatherAPI.com / OpenWeatherMap.
  - **Demo / Mock Mode**: Fallback otomatis ke dataset simulasi lokal jika API Key kosong atau jaringan terputus, menjaga aplikasi tidak pernah mengalami *crash*.
- **Deteksi Lokasi GPS Otomatis**:
  - Menggunakan paket `geolocator` untuk mendeteksi koordinat lintang & bujur perangkat secara otomatis.
  - Fitur dialog umpan balik ramah pengguna (*LocationFeedbackDialog*) jika GPS nonaktif atau izin belum diberikan.

### 5. Desain Sistem & Glassmorphism
- **Signature Blue Gradient Glassmorphism**:
  - Memadukan efek blur Gaussian (`BackdropFilter`), gradasi tiga warna lembut (*Soft Ice Sky*, *Frosted White-Blue*, dan *Ambient Blue Accent*), border kaca bercahaya (`AppColors.glassBorder`), serta bayangan aksen primer.
- **Tipografi Modern**: Menggunakan font Google **Outfit** yang bersih dan kontras.
- **Navigasi Kapsul Mengambang (*Floating Bottom Navigation*)**: Navigasi bawah melayang yang memudahkan perpindahan antara Beranda, Kalender, dan Lokasi.

---

## 🛠️ Teknologi yang Digunakan

| Komponen | Teknologi / Paket | Deskripsi |
| :--- | :--- | :--- |
| **Framework** | [Flutter 3.x](https://flutter.dev/) | Framework UI lintas platform dari Google |
| **Bahasa** | [Dart 3.13+](https://dart.dev/) | Bahasa pemrograman berorientasi objek yang tangguh |
| **Networking** | [`http: ^1.6.0`](https://pub.dev/packages/http) | Komunikasi HTTP REST API |
| **Environment** | [`flutter_dotenv: ^6.0.1`](https://pub.dev/packages/flutter_dotenv) | Pengelolaan API Key melalui berkas `.env` aman |
| **Geolokasi** | [`geolocator: ^14.1.2`](https://pub.dev/packages/geolocator) | Akses GPS dan koordinat perangkat |
| **Ikon** | `cupertino_icons` & Material Icons | Kumpulan ikon modern iOS & Android |
| **Tipografi** | [Outfit Font](https://fonts.google.com/specimen/Outfit) | Tipografi sans-serif modern |
| **Testing** | `flutter_test` | Pengujian unit test dan widget test otomatis |

---

## 📁 Struktur Direktori Proyek

```text
WeatherMe/
├── assets/                    # Aset statis aplikasi
│   ├── fonts/outfit/          # Berkas font lokal Outfit (400, 500, 600, 700, 800)
│   └── logo/                  # Identitas logo aplikasi (WeatherMe.png)
├── lib/
│   ├── core/
│   │   └── config/
│   │       └── api_config.dart        # Konfigurasi endpoint, base URL, dan API key
│   ├── data/
│   │   ├── models/
│   │   │   └── weather_model.dart     # Parser respons JSON ke model domain WeatherMe
│   │   └── services/
│   │       ├── location_service.dart  # Layanan GPS & izin lokasi (geolocator)
│   │       ├── weather_controller.dart # State management terpusat (ChangeNotifier)
│   │       └── weather_service.dart   # HTTP Client, caching, timeout, & fallback
│   ├── models/
│   │   └── weather_models.dart        # Model data CurrentWeather, Forecast, CityWeather
│   ├── screens/
│   │   ├── calendar_screen.dart       # Halaman Kalender Cuaca & Prakiraan 7 Hari
│   │   ├── home_screen.dart           # Halaman Beranda & Perkiraan Cuaca
│   │   └── locations_screen.dart      # Halaman Pengelolaan & Pencarian Lokasi
│   ├── theme/
│   │   ├── app_colors.dart            # Token warna tema & token Glassmorphism
│   │   ├── app_theme.dart             # ThemeData Material 3
│   │   └── app_typography.dart        # Hierarki tipografi Outfit
│   ├── widgets/                       # Komponen UI modular
│   │   ├── add_city_bottom_sheet.dart # Modal pop-up tambah lokasi
│   │   ├── app_background.dart        # Background dengan aksen pendaran gradasi
│   │   ├── city_search_bar.dart       # Bilah pencarian kota glassmorphism
│   │   ├── current_location_card.dart # Kartu cuaca lokasi saat ini
│   │   ├── current_weather_card.dart  # Hero card cuaca di Beranda
│   │   ├── hourly_forecast.dart       # Perkiraan cuaca per jam real-time
│   │   ├── location_feedback_dialog.dart # Dialog bantuan izin & layanan GPS
│   │   ├── saved_city_card.dart       # Kartu item kota tersimpan
│   │   ├── selected_day_forecast_card.dart # Kartu detail hari terpilih di Kalender
│   │   ├── weather_bottom_navigation.dart  # Bilah navigasi bawah mengambang
│   │   ├── weather_calendar.dart      # Kalender bulanan interaktif
│   │   ├── weather_icon.dart          # Ikon cuaca berbasis kondisi
│   │   ├── weather_illustration.dart  # Ilustrasi matahari & awan bertingkat
│   │   └── weekly_forecast_list.dart  # Daftar perkiraan 3 & 7 hari ke depan
│   └── main.dart                      # Titik masuk utama aplikasi (main entry)
├── test/                              # Pengujian otomatis
│   ├── location_feature_test.dart     # Unit test integrasi geolokasi & dialog GPS
│   ├── weather_api_test.dart          # Unit test parsing JSON API & fallback
│   └── widget_test.dart               # Smoke test & navigasi seluruh halaman
├── .env.example                       # Contoh template API key
├── pubspec.yaml                       # Deklarasi dependensi & aset
└── README.md                          # Dokumentasi resmi proyek
```

---

## 💻 Persyaratan Sistem

Pastikan komputer pengembangan Anda memenuhi spesifikasi berikut:
- **Flutter SDK**: Versi `3.13.4` atau yang lebih baru (Channel Stable).
- **Dart SDK**: Versi `^3.13.4`.
- **Perangkat Sasaran**:
  - **Android**: Android Studio dengan Android SDK (API Level 21+) / Emulator.
  - **iOS**: macOS dengan Xcode (untuk target iOS).
  - **Web**: Google Chrome atau browser modern lainnya.
- **Git**: Versi 2.x atau yang lebih baru.

---

## ⚙️ Panduan Instalasi & Menjalankan

Ikuti langkah-langkah praktis berikut untuk menjalankan proyek di komputer lokal Anda:

### 1. Kloning Repositori
```bash
git clone https://github.com/mizanyf/WeatherMe.git
cd WeatherMe
```

### 2. Pasang Dependensi
```bash
flutter pub get
```

### 3. Siapkan Berkas Konfigurasi Lingkungan (`.env`)
Salin template berkas lingkungan:
```bash
# Untuk Windows (Command Prompt / PowerShell)
copy .env.example .env

# Untuk macOS / Linux
cp .env.example .env
```
*(Lihat bagian [Konfigurasi API Cuaca](#-konfigurasi-api-cuaca-env) untuk langkah pengisian API Key).*

### 4. Jalankan Pengujian Otomatis
Pastikan seluruh 20 test skenario pengujian berjalan hijau:
```bash
flutter test
```

### 5. Jalankan Aplikasi
Pilih target yang Anda inginkan:
```bash
# Menjalankan pada Google Chrome (Web)
flutter run -d chrome

# Menjalankan pada perangkat fisik / emulator aktif
flutter run
```

---

## 🔑 Konfigurasi API Cuaca (`.env`)

WeatherMe mendukung data cuaca langsung dari **[WeatherAPI.com](https://www.weatherapi.com/)**:

1. Kunjungi [WeatherAPI Signup](https://www.weatherapi.com/signup.aspx) dan buat akun gratis.
2. Salin string **API Key** dari dashboard akun Anda.
3. Buka berkas `.env` pada direktori root proyek dan masukkan API Key:
   ```env
   # WeatherMe - Konfigurasi API Environment
   WEATHER_API_KEY=masukkan_api_key_anda_di_sini
   ```

> [!TIP]
> Berkas `.env` telah didaftarkan pada `.gitignore` sehingga API Key Anda aman dan tidak akan terunggah ke repositori publik GitHub. Jika API Key tidak diisi, WeatherMe akan otomatis berjalan dalam **Mode Demo (Mock Data)** yang tetap interaktif.

---

## 🧪 Pengujian Kualitas Kode (Testing)

WeatherMe menerapkan standar kode yang ketat dan andal dengan cakupan pengujian komprehensif:

- **Analisis Statis Dart**:
  ```bash
  flutter analyze
  ```
  *Hasil: **No issues found!** (0 error / 0 warning).*

- **Rangkaian Pengujian Otomatis**:
  ```bash
  flutter test
  ```
  *Hasil: **20/20 Test Passed!** mencakup:*
  - Smoke test seluruh navigasi halaman (Beranda, Kalender, Lokasi).
  - Validasi parsing respons JSON API cuaca (suhu, jam mendatang, kondisi).
  - Pengujian ketersediaan tanggal kalender (7 hari ke belakang & 7 hari ke depan).
  - Pengujian alur izin lokasi perangkat (GPS aktif, izin ditolak, fallback manual).

---

## 🤝 Kontribusi

Kontribusi selalu diterima dengan tangan terbuka! Untuk berkontribusi:

1. **Fork** repositori ini ke akun GitHub Anda.
2. Buat branch fitur baru:
   ```bash
   git checkout -b feature/FiturKerenBaru
   ```
3. Lakukan perubahan kode dan jalankan pengujian:
   ```bash
   flutter test
   ```
4. Commit perubahan dengan pesan deskriptif:
   ```bash
   git commit -m "feat: Menambahkan animasi transisi cuaca"
   ```
5. Dorong branch ke GitHub:
   ```bash
   git push origin feature/FiturKerenBaru
   ```
6. Ajukan **Pull Request (PR)** baru.

---

## 📄 Lisensi

Proyek ini dirilis di bawah lisensi [MIT License](LICENSE) — bebas digunakan untuk pembelajaran, portofolio, maupun pengembangan lebih lanjut.

---

## 👨‍💻 Pengembang

- **Repositori Resmi**: [https://github.com/mizanyf/WeatherMe](https://github.com/mizanyf/WeatherMe)
- **Author / Pengembang**: [mizanyf](https://github.com/mizanyf)

<p align="center">
  Dibuat dengan ❤️ menggunakan Flutter & Dart.
</p>
