# WeatherMe

<p align="center">
  <img src="assets/logo/WeatherMe.png" alt="WeatherMe Logo" width="120" style="border-radius: 24px;" />
</p>

<p align="center">
  <strong>Aplikasi prakiraan cuaca modern berbasis Flutter dengan antarmuka elegan, minimalis, dan sentuhan visual Glassmorphism.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue" alt="Platform" />
  <img src="https://img.shields.io/badge/License-Belum%20Ditentukan-lightgrey" alt="License" />
</p>

---

## Daftar Isi

- [Gambaran Umum](#gambaran-umum)
- [Fitur Aplikasi](#fitur-aplikasi)
- [Tampilan Aplikasi](#tampilan-aplikasi)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Struktur Direktori](#struktur-direktori)
- [Persyaratan Sistem](#persyaratan-sistem)
- [Instalasi dan Menjalankan Proyek](#instalasi-dan-menjalankan-proyek)
- [Konfigurasi API Cuaca](#konfigurasi-api-cuaca)
- [Cara Menggunakan Aplikasi](#cara-menggunakan-aplikasi)
- [Status Pengembangan](#status-pengembangan)
- [Rencana Pengembangan](#rencana-pengembangan)
- [Kontribusi](#kontribusi)
- [Lisensi](#lisensi)
- [Pengembang dan Repositori](#pengembang-dan-repositori)

---

## Gambaran Umum

**WeatherMe** adalah aplikasi pemantau cuaca lintas platform (*cross-platform*) yang dibangun menggunakan Flutter framework. Proyek ini dikembangkan sebagai representasi karya portofolio mahasiswa bidang Teknologi Informasi yang menitikberatkan pada perancangan antarmuka pengguna (UI/UX) modern, arsitektur kode modular, dan penerapan komponen antarmuka yang bersih serta konsisten.

Aplikasi ini bertujuan membantu pengguna memantau kondisi cuaca saat ini, merencanakan agenda harian berdasarkan proyeksi cuaca per jam, memeriksa prakiraan jangka panjang melalui kalender terpadu, serta menelusuri informasi cuaca di berbagai kota dunia dalam satu wadah antarmuka yang intuitif dan nyaman dipandang.

### Sasaran Platform
- **Android** (Smartphone & Tablet)
- **iOS** (iPhone & iPad)
- **Web** (Desktop & Mobile Browser)

---

## Fitur Aplikasi

Saat ini, seluruh antarmuka dan interaksi pengguna telah diimplementasikan dengan memanfaatkan model data simulasi lokal (*mock data*). Fitur-fitur utama yang tersedia meliputi:

### 1. Halaman Beranda (Home)
- **Kartu Cuaca Utama (*Current Weather Hero Card*)**: Menampilkan kondisi cuaca terkini, nama lokasi, suhu aktual (°C), rentang suhu maksimum/minimum harian, tanggal dan waktu pembaruan data, serta ilustrasi visual cuaca bertingkat (*layered weather illustration*).
- **Prakiraan Cuaca Per Jam (*Hourly Forecast*)**: Deretan kartu horisontal yang dapat digulir, memperlihatkan proyeksi suhu dan ikon cuaca pada jam-jam mendatang dengan indikator visual khusus untuk kartu "Sekarang".
- **Prakiraan Cuaca 3 Hari (*3-Day Forecast*)**: Ringkasan perkiraan cuaca tiga hari ke depan yang dilengkapi indikator rentang suhu (*temperature bar*) dan tautan cepat menuju halaman Kalender.

### 2. Halaman Kalender Cuaca (Calendar)
- **Kalender Cuaca Bulanan Interaktif (*Weather Calendar*)**: Tampilan kalender bulanan lengkap dengan navigasi perpindahan bulan (sebelumnya/berikutnya) dan pemilihan tanggal interaktif.
- **Fokus Prakiraan Harian (*Selected Day Forecast Detail*)**: Kartu informasi mendalam untuk tanggal yang sedang dipilih pada kalender, menyajikan:
  - Kondisi cuaca dan temperatur.
  - Batas suhu maksimum dan minimum.
  - Peluang terjadinya hujan (*rain chance*).
  - Tingkat kelembapan udara (*humidity*).
  - Kecepatan angin (*wind speed*).
  - Indeks radiasi sinar ultraviolet (*UV index*).
- **Prakiraan 7 Hari Mendatang (*Weekly Forecast List*)**: Daftar terperinci prakiraan cuaca selama sepekan ke depan lengkap dengan persentase presipitasi dan visualisasi rentang suhu harian.

### 3. Halaman Jelajahi Lokasi (Locations)
- **Pencarian Kota Real-time (*City Search Bar*)**: Kolom pencarian responsif untuk menyaring daftar kota tersimpan berdasarkan nama kota atau negara, dilengkapi tombol pembersih pencarian sekali sentuh.
- **Kartu Lokasi Aktif (*Current Location Card*)**: Menampilkan kota yang sedang dijadikan acuan aktif beserta data temperatur, status cuaca, dan penanda waktu lokal.
- **Daftar Kota Tersimpan (*Saved Cities List*)**: Kumpulan kartu kota yang telah disimpan pengguna (misal: Jakarta, Tokyo, London, Sydney). Mengetuk kartu kota akan langsung mengubahnya menjadi lokasi cuaca aktif.
- **Tambah Kota Baru (*Add City Bottom Sheet*)**: Lembar interaktif bawah (*modal bottom sheet*) untuk menelusuri katalog kota yang tersedia (*cities pool*), memfilter nama kota/negara, serta menyimpannya ke daftar utama dengan validasi pencegahan duplikasi.

### 4. Desain Sistem & Pengalaman Pengguna (UI/UX)
- **Estetika Glassmorphism Modern**: Pemanfaatan efek kaca buram (*frosted glass*) dengan `BackdropFilter` (Gaussian blur), batas tepi bercahaya halus (*luminous glass border*), dan bayangan bertingkat yang memberikan kesan visual elegan dan berkedalaman (*depth*).
- **Komponen Ilustrasi Cuaca Native**: Ilustrasi matahari bersinar dan awan bertumpuk yang dirancang murni menggunakan komponen bawaan Flutter (`Stack`, `Container`, `RadialGradient`, dan `BoxShadow`) tanpa membebani ukuran aplikasi dengan gambar vektor atau bitmap pihak ketiga yang berat.
- **Navigasi Kapsul Mengambang (*Floating Bottom Navigation*)**: Bilah navigasi semi-transparan bergaya kapsul mengambang di bagian bawah layar yang memudahkan perpindahan antara Beranda, Kalender, dan Lokasi.

> [!NOTE]
> **Status Data Cuaca**: Data kondisi, suhu, dan prakiraan yang ditampilkan pada versi ini masih bersumber dari simulasi data lokal (*mock data*) yang didefinisikan pada `lib/models/weather_models.dart`. Integrasi REST API cuaca nyata akan dihubungkan pada tahap pengembangan berikutnya.

---

## Tampilan Aplikasi

Dokumentasi visual tangkapan layar antarmuka aplikasi WeatherMe:

| Beranda (*Home*) | Kalender Cuaca (*Calendar*) | Jelajahi Lokasi (*Locations*) |
| :---: | :---: | :---: |
| *(Tangkapan layar sedang dipersiapkan)* | *(Tangkapan layar sedang dipersiapkan)* | *(Tangkapan layar sedang dipersiapkan)* |

> [!NOTE]
> Berkas dokumentasi visual (*screenshot*) beresolusi tinggi akan diperbarui dan ditambahkan ke direktori dokumentasi repository pada pembaruan mendatang setelah sesi pengujian tampilan pada perangkat fisik diselesaikan.

---

## Teknologi yang Digunakan

Aplikasi WeatherMe dibangun menggunakan teknologi dan pustaka berikut:

- **Framework Utama**: [Flutter](https://flutter.dev/) (Channel stable, mendukung UI multiplatform)
- **Bahasa Pemrograman**: [Dart](https://dart.dev/) (SDK Versi `^3.13.4`)
- **Desain Sistem & Antarmuka**: Material 3 Design System dengan penyesuaian tema kustom Glassmorphism
- **Tipografi**: [Outfit Font Family](https://fonts.google.com/specimen/Outfit) (Tersedia lokal dalam varian Regular, Medium, SemiBold, Bold, dan ExtraBold)
- **Paket Ikon**:
  - `cupertino_icons: ^1.0.8` (Ikon pendukung iOS style)
  - Material Icons bawaan Flutter
- **Pengujian & Kualitas Kode**:
  - `flutter_test` (Pengujian widget dan alur navigasi otomatis)
  - `flutter_lints: ^6.0.0` (Standar aturan dan konvensi penulisan kode Dart)

---

## Struktur Direktori

Berikut adalah struktur organisasi berkas pada proyek WeatherMe:

```text
WeatherMe/
├── android/                   # Konfigurasi proyek native untuk platform Android
├── assets/                    # Berkas aset statis aplikasi
│   ├── fonts/                 # Berkas font lokal (Outfit)
│   │   └── outfit/            # Varian ketebalan font Outfit (400, 500, 600, 700, 800)
│   └── logo/                  # Berkas identitas visual dan logo aplikasi (WeatherMe.png)
├── ios/                       # Konfigurasi proyek native untuk platform iOS
├── lib/                       # Direktori utama kode sumber Flutter
│   ├── core/                  # Konfigurasi inti aplikasi
│   │   └── config/
│   │       └── api_config.dart # Endpoint, base URL, timeout, dan variabel konfigurasi API
│   ├── data/                  # Lapisan integrasi data dan komunikasi API
│   │   ├── models/
│   │   │   └── weather_model.dart # Parser respons JSON WeatherAPI ke model WeatherMe
│   │   └── services/
│   │       └── weather_service.dart # HTTP client, auth, timeout, & error handling
│   ├── models/                # Definisi struktur data model dan kumpulan data simulasi
│   │   └── weather_models.dart      # Model CurrentWeather, Forecast, CityWeather, mock data
│   ├── screens/               # Halaman utama aplikasi
│   │   ├── calendar_screen.dart     # Halaman Kalender Cuaca & Prakiraan 7 Hari
│   │   ├── home_screen.dart         # Halaman Beranda & Ringkasan Cuaca Terkini
│   │   └── locations_screen.dart    # Halaman Pengelolaan dan Penjelajahan Lokasi Kota
│   ├── theme/                 # Konfigurasi tema global dan token desain
│   │   ├── app_colors.dart          # Palet warna primer, netral, aksen, dan token Glassmorphism
│   │   ├── app_theme.dart           # Konfigurasi ThemeData Material 3
│   │   └── app_typography.dart      # Hierarki teks dan gaya tipografi font Outfit
│   ├── widgets/               # Komponen antarmuka pengguna modular dan reusable
│   │   ├── add_city_bottom_sheet.dart    # Modal pencarian dan penambahan kota baru
│   │   ├── app_background.dart           # Background aplikasi dengan aksen glass biru di sudut layar
│   │   ├── calendar_header.dart          # Header judul dan selektor lokasi halaman kalender
│   │   ├── city_search_bar.dart          # Komponen bilah input pencarian kota
│   │   ├── current_location_card.dart    # Kartu lokasi cuaca aktif halaman lokasi
│   │   ├── current_weather_card.dart     # Kartu pahlawan (hero card) cuaca saat ini
│   │   ├── current_weather_metrics_card.dart # Kartu indikator cuaca terpisah (Hujan, UV, dsb.)
│   │   ├── daily_forecast_tile.dart      # Baris prakiraan cuaca 3 harian
│   │   ├── glass_surface.dart            # Wrapper komponen efek Glassmorphism
│   │   ├── hourly_forecast.dart          # Kartu geser prakiraan cuaca per jam
│   │   ├── locations_header.dart         # Header halaman lokasi
│   │   ├── saved_city_card.dart          # Kartu item daftar kota tersimpan
│   │   ├── selected_day_forecast_card.dart # Kartu fokus prakiraan hari terpilih
│   │   ├── top_header.dart               # Header atas aplikasi (Logo & Wordmark WeatherMe)
│   │   ├── weather_bottom_navigation.dart # Bilah navigasi bawah mengambang
│   │   ├── weather_calendar.dart         # Kalender interaktif bulanan
│   │   ├── weather_detail_card.dart      # Kartu informasi indikator spesifik cuaca
│   │   ├── weather_illustration.dart     # Ilustrasi grafis matahari dan awan native Flutter
│   │   └── weekly_forecast_list.dart     # Komponen daftar prakiraan 7 hari ke depan
│   └── main.dart              # Titik masuk utama (entry point) aplikasi
├── test/                      # Berkas pengujian otomatis
│   ├── weather_api_test.dart  # Unit test pengujian parsing JSON dan konfigurasi API
│   └── widget_test.dart       # Uji asap (smoke test) dan validasi interaksi komponen UI
├── web/                       # Konfigurasi proyek native untuk platform Web
├── .env                       # Berkas kredensial API Key lokal (diabaikan oleh Git)
├── .env.example               # Template variabel lingkungan untuk API Key
├── pubspec.yaml               # Deklarasi dependensi, aset font/logo, dan metadata paket
└── README.md                  # Dokumentasi proyek
```

---

## Persyaratan Sistem

Sebelum menjalankan proyek ini, pastikan lingkungan pengembangan (*development environment*) Anda telah memenuhi spesifikasi berikut:

1. **Flutter SDK**: Versi `3.13.4` atau yang lebih baru (disarankan versi stabil terbaru).
2. **Dart SDK**: Versi `>=3.13.4 <4.0.0` (otomatis terpasang bersama Flutter SDK).
3. **Target Platform & Alat Bantu**:
   - **Android**: Android Studio dengan Android SDK (API Level 21+) serta Android Emulator atau perangkat fisik dengan mode *USB Debugging* aktif.
   - **iOS / macOS**: macOS dengan Xcode terpasang (untuk menjalankan target iOS).
   - **Web**: Google Chrome atau browser modern berbasis Chromium.
4. **Git**: Versi 2.x atau yang lebih baru untuk manajemen versi kode.

---

## Instalasi dan Menjalankan Proyek

Ikuti langkah-langkah di bawah ini untuk mengunduh dan menjalankan aplikasi di komputer lokal:

### 1. Kloning Repositori
Unduh salinan kode sumber dari GitHub ke komputer lokal Anda:
```bash
git clone https://github.com/mizanyf/WeatherMe.git
cd WeatherMe
```

### 2. Unduh Dependensi
Jalankan perintah berikut untuk mengunduh semua paket dependensi dan mendaftarkan aset:
```bash
flutter pub get
```

### 3. Verifikasi Pemeriksaan Kode & Pengujian
Jalankan pengujian widget otomatis untuk memastikan seluruh modul UI dan navigasi berjalan normal:
```bash
flutter test
```

### 4. Jalankan Aplikasi
Pilih salah satu target perangkat yang terhubung:

- **Menjalankan pada perangkat fisik atau emulator aktif**:
  ```bash
  flutter run
  ```

- **Menjalankan pada peramban web (Google Chrome)**:
  ```bash
  flutter run -d chrome
  ```

---

## Konfigurasi API Cuaca

WeatherMe telah dilengkapi arsitektur integrasi API resmi menggunakan penyedia layanan **[WeatherAPI.com](https://www.weatherapi.com/)**. Layanan ini dipilih karena menyediakan data cuaca real-time yang lengkap (suhu, kelembapan, angin, UV index, prakiraan per jam & harian), registrasi gratis tanpa membutuhkan kartu kredit, serta kuota penggunaan hingga 1.000.000 panggilan per bulan.

### 1. Cara Mendapatkan API Key Gratis
1. Buka laman pendaftaran resmi WeatherAPI di [https://www.weatherapi.com/signup.aspx](https://www.weatherapi.com/signup.aspx).
2. Daftarkan akun gratis menggunakan email Anda.
3. Setelah masuk, buka halaman **Dashboard** akun Anda.
4. Salin string **API Key** yang tertera pada dashboard.

### 2. Memasukkan API Key ke Berkas `.env`
Buka berkas `.env` yang berada di direktori root proyek (sejajar dengan `pubspec.yaml`), lalu tempelkan API Key Anda:

```env
# WeatherMe - API Configuration Environment
WEATHER_API_KEY=masukkan_api_key_anda_di_sini
```

> [!TIP]
> Berkas `.env` telah secara otomatis didaftarkan pada `.gitignore` dan tidak akan pernah terunggah ke repositori publik GitHub, menjaga kerahasiaan kredensial akun Anda. Jika berkas `.env` belum tersedia, Anda dapat menyalin dari `.env.example`.

### 3. Arsitektur dan Alur Komunikasi Data
Modul API pada WeatherMe dibangun dengan pemisahan tanggung jawab yang bersih:
- **`lib/core/config/api_config.dart`**: Menyimpan base URL (`https://api.weatherapi.com/v1`), rute endpoint (`/forecast.json`, `/current.json`, `/search.json`), timeout request (12 detik), dan helper validasi API key.
- **`lib/data/services/weather_service.dart`**: Service HTTP yang menangani request jaringan, autentikasi, status code handling (400, 401, 403, 429, 500), timeout exception, serta caching respons terakhir untuk efisiensi kuota.
- **`lib/data/models/weather_model.dart`**: Parser respons JSON yang tangguh (*defensive parsing*) dan mengonversi payload API ke objek domain UI WeatherMe (`CurrentWeather`, `HourlyForecast`, `DailyForecast`, `CalendarDayForecast`).

### 4. Mode Demo Otomatis (Fallback)
Aplikasi dirancang agar **tidak pernah crash** meskipun API Key belum diisi atau perangkat sedang tidak terhubung ke jaringan:
- **Jika API Key belum diisi**: Aplikasi secara otomatis aktif dalam **Mode Demo (Mock Data)**. Banner status pada Beranda akan menampilkan badge *"Mode Demo (Mock Data)"* dan seluruh antarmuka tetap berjalan normal menggunakan dataset simulasi.
- **Jika API Key valid terdeteksi**: Aplikasi beralih menampilkan badge *"Live API (WeatherAPI)"* dengan data cuaca riil dari kota acuan (default: Malang, Indonesia) yang dapat diperbarui kapan saja menggunakan fitur **Pull-to-Refresh**.
- **Jika terjadi gangguan jaringan**: Aplikasi menampilkan pesan kesalahan yang ramah pengguna beserta tombol **"Coba Lagi"** (*Retry*) tanpa merusak tata letak antarmuka.

---

## Cara Menggunakan Aplikasi

1. **Melihat Cuaca Terkini**:
   - Pada halaman **Beranda**, periksa kartu utama untuk mengetahui suhu dan cuaca di kota aktif saat ini (standar awal: Malang, Indonesia).
   - Geser bagian **Prakiraan Hari Ini** ke arah kanan untuk memantau perubahan temperatur pada jam-jam mendatang.
   - Tinjau **Prakiraan 3 Hari** untuk ringkasan cepat kondisi cuaca beberapa hari ke depan.

2. **Mengecek Prakiraan Melalui Kalender**:
   - Ketuk tab **Kalender** pada bilah navigasi bawah (atau ketuk tombol *"Lihat Kalender"* pada Beranda).
   - Pilih tanggal yang diinginkan pada kalender bulanan.
   - Kartu **Fokus Prakiraan** akan memperbarui rincian cuaca harian (peluang hujan, kelembapan, kecepatan angin, dan indeks UV) sesuai tanggal yang dipilih.
   - Gulir ke bawah untuk meninjau rincian **Prakiraan 7 Hari Mendatang**.

3. **Mencari dan Mengelola Kota**:
   - Ketuk tab **Lokasi** pada bilah navigasi bawah.
   - Gunakan kolom pencarian untuk menyaring kota yang sudah disimpan.
   - Ketuk salah satu kartu kota yang tersimpan untuk beralih dan menjadikannya sebagai lokasi cuaca aktif.
   - Ketuk tombol **"+ Tambah Kota"** untuk membuka jendela pemilihan kota baru dari katalog yang tersedia, lalu pilih kota untuk menambahkannya ke dalam daftar tersimpan.

---

## Status Pengembangan

Proyek WeatherMe saat ini berada dalam tahap: **Pengembangan Aktif (*Active Development / UI & UX Refinement*)**.

Berikut adalah rincian status fitur saat ini:

| Modul / Fitur | Status | Keterangan |
| :--- | :---: | :--- |
| Tampilan Beranda (*Home UI*) | Selesai | Layout responsif, kartu hero cuaca, prakiraan per jam, dan 3 hari |
| Tampilan Kalender (*Calendar UI*) | Selesai | Kalender bulanan interaktif dan fokus detail parameter cuaca |
| Tampilan Lokasi (*Locations UI*) | Selesai | Pencarian kota, pengelolaan kota tersimpan, dan modal tambah kota |
| Desain Glassmorphism & Tema | Selesai | Komponen `GlassSurface`, palet warna terpusat, dan tipografi Outfit |
| Pengujian Widget (*Widget Tests*) | Selesai | Seluruh skenario pengujian smoke test dan interaksi halaman lulus |
| Integrasi REST API Cuaca | Direncanakan | Masih menggunakan data simulasi lokal (*mock data*) |
| Deteksi Lokasi Otomatis (GPS) | Direncanakan | Memerlukan modul geolokasi perangkat fisik |
| Penyimpanan Lokal Persisten | Direncanakan | Menyimpan riwayat kota dengan SharedPreferences/Hive |
| Mode Gelap (*Dark Mode*) | Direncanakan | Menyiapkan variasi tema Glassmorphism bertema malam/gelap |

---

## Rencana Pengembangan

Rencana pembaruan yang menjadi prioritas pada tahap pengembangan selanjutnya meliputi:

- [ ] **Integrasi REST API Cuaca**: Mengintegrasikan penyedia data cuaca real-time (misal OpenWeatherMap atau WeatherAPI) melalui HTTP client.
- [ ] **Deteksi Lokasi GPS Otomatis**: Menambahkan paket `geolocator` untuk mendeteksi koordinat lintang dan bujur pengguna secara otomatis saat aplikasi dibuka.
- [ ] **Penyimpanan Lokal Persisten**: Menggunakan `shared_preferences` atau `hive` agar daftar kota tersimpan tidak tereset saat aplikasi ditutup.
- [ ] **Mode Gelap (*Dark Theme*)**: Menyediakan opsi beralih antara tema terang (*Light Ice Sky*) dan tema gelap (*Deep Slate Navy Glassmorphism*).
- [ ] **Peringatan Cuaca Ekstrem**: Menyediakan notifikasi kondisi cuaca darurat atau hujan lebat yang diproyeksikan.
- [ ] **Penyempurnaan Aksesibilitas**: Memastikan kontras warna ramah pembaca dan mendukung fitur pembaca layar (*screen reader*).

---

## Kontribusi

Kontribusi pada pengembangan WeatherMe sangat terbuka. Jika Anda ingin berpartisipasi dalam menyempurnakan fitur atau memperbaiki kendala:

1. Lakukan **Fork** pada repositori ini.
2. Buat branch fitur baru pada repositori lokal Anda:
   ```bash
   git checkout -b feature/NamaFiturKeren
   ```
3. Lakukan perubahan kode dan pastikan sesuai dengan panduan gaya kode Flutter.
4. Jalankan pengujian otomatis untuk memastikan tidak ada fitur yang terganggu:
   ```bash
   flutter test
   ```
5. Simpan perubahan Anda dengan pesan commit yang deskriptif:
   ```bash
   git commit -m "feat: Menambahkan integrasi REST API cuaca"
   ```
6. Dorong branch Anda ke GitHub:
   ```bash
   git push origin feature/NamaFiturKeren
   ```
7. Buat **Pull Request** baru melalui antarmuka GitHub dan jelaskan rincian perubahan yang Anda ajukan.

---

## Lisensi

Saat ini, repositori ini **belum menyertakan lisensi perangkat lunak open-source formal**. Seluruh hak cipta awal dimiliki oleh pengembang proyek. Jika Anda tertarik untuk memanfaatkan, mengutip, atau mendistribusikan kode sumber dalam repositori ini, silakan menghubungi pengembang terlebih dahulu.

---

## Pengembang dan Repositori

- **Repositori Resmi**: [https://github.com/mizanyf/WeatherMe](https://github.com/mizanyf/WeatherMe)
- **Pengembang**: [mizanyf](https://github.com/mizanyf)
