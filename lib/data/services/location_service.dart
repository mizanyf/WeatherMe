import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Status hasil dari permintaan akses lokasi perangkat
enum LocationStatus {
  success,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  locationError,
}

/// Representasi hasil dari operasi penentuan posisi lokasi perangkat
class LocationResult {
  final LocationStatus status;
  final Position? position;
  final String? errorMessage;

  const LocationResult({
    required this.status,
    this.position,
    this.errorMessage,
  });

  bool get isSuccess => status == LocationStatus.success && position != null;

  @override
  String toString() =>
      'LocationResult(status: $status, pos: $position, error: $errorMessage)';
}

/// Service untuk menangani perolehan izin lokasi dan koordinat perangkat
/// menggunakan package [geolocator] serta fallback geolokasi IP jaringan.
class LocationService {
  /// Singleton instance untuk kemudahan akses di seluruh aplikasi
  static LocationService instance = LocationService();

  final http.Client _httpClient;

  LocationService({http.Client? client}) : _httpClient = client ?? http.Client();

  /// Memeriksa status layanan lokasi (GPS) dan izin, kemudian mengambil posisi koordinat perangkat.
  ///
  /// Mengembalikan [LocationResult] yang merefleksikan status keberhasilan atau jenis kendala
  /// yang dialami (layanan mati, izin ditolak, izin ditolak permanen, atau kesalahan penentuan koordinat).
  Future<LocationResult> determinePosition() async {
    // 1. Periksa apakah layanan lokasi (GPS) pada perangkat aktif
    // Catatan: Pada Web, browser tidak mendukung channel pengecekan GPS hardware secara langsung,
    // izin dan ketersediaan lokasi ditangani langsung saat getCurrentPosition() dipanggil.
    if (!kIsWeb) {
      bool serviceEnabled = true;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (_) {
        // Jika platform tidak mendukung method channel ini, lewati ke pengecekan izin
      }

      if (!serviceEnabled) {
        return const LocationResult(
          status: LocationStatus.serviceDisabled,
          errorMessage:
              'Layanan lokasi (GPS) pada perangkat Anda tidak aktif. Silakan aktifkan GPS.',
        );
      }
    }

    // 2. Periksa status izin lokasi saat ini
    LocationPermission permission = LocationPermission.whileInUse;
    try {
      permission = await Geolocator.checkPermission();
    } catch (_) {
      // Abaikan jika platform tidak mendukung checkPermission terpisah
    }

    if (permission == LocationPermission.denied) {
      // Minta izin ke pengguna
      try {
        permission = await Geolocator.requestPermission();
      } catch (_) {}

      if (permission == LocationPermission.denied) {
        // Coba fallback IP geolocation jika di Web/PC pengguna sudah allow namun status masih denied
        final ipPos = await _getIpFallbackPosition();
        if (ipPos != null) {
          return LocationResult(
            status: LocationStatus.success,
            position: ipPos,
          );
        }

        return const LocationResult(
          status: LocationStatus.permissionDenied,
          errorMessage:
              'Izin lokasi ditolak. Anda dapat mengizinkan akses lokasi atau mencari kota secara manual.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Pada Web, coba fallback IP sebelum menyerah jika browser tidak menyediakan GPS satelit
      if (kIsWeb) {
        final ipPos = await _getIpFallbackPosition();
        if (ipPos != null) {
          return LocationResult(
            status: LocationStatus.success,
            position: ipPos,
          );
        }
      }

      return const LocationResult(
        status: LocationStatus.permissionDeniedForever,
        errorMessage:
            'Izin lokasi ditolak permanen. Buka pengaturan untuk mengizinkan akses lokasi, atau cari kota secara manual.',
      );
    }

    // 3. Izin sudah diberikan (whileInUse atau always) -> Ambil koordinat perangkat
    try {
      // Pada Web/PC desktop yang tidak memiliki chip GPS satelit, gunakan medium/low
      // agar browser menggunakan geolokasi berbasis jaringan/Wi-Fi Google tanpa error POSITION_UNAVAILABLE
      final locationSettings = LocationSettings(
        accuracy: kIsWeb ? LocationAccuracy.medium : LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      return LocationResult(
        status: LocationStatus.success,
        position: position,
      );
    } catch (firstError) {
      // Fallback kedua: coba dengan accuracy low jika high/medium gagal di desktop/laptop
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 8),
          ),
        );

        return LocationResult(
          status: LocationStatus.success,
          position: position,
        );
      } catch (_) {
        // Fallback ketiga: Ambil koordinat posisi terakhir yang diketahui
        try {
          final lastKnown = await Geolocator.getLastKnownPosition();
          if (lastKnown != null) {
            return LocationResult(
              status: LocationStatus.success,
              position: lastKnown,
            );
          }
        } catch (_) {}

        // Fallback keempat: Gunakan IP Geolocation jaringan
        // Solusi sangat efektif untuk laptop/desktop PC di mana browser tidak memiliki sensor GPS hardware
        final ipPos = await _getIpFallbackPosition();
        if (ipPos != null) {
          return LocationResult(
            status: LocationStatus.success,
            position: ipPos,
          );
        }

        return const LocationResult(
          status: LocationStatus.locationError,
          errorMessage:
              'Gagal mendapatkan koordinat perangkat. Anda dapat mencari kota secara manual.',
        );
      }
    }
  }

  /// Mengambil perkiraan koordinat pengguna menggunakan geolokasi IP jaringan (HTTPS)
  /// Sangat berguna untuk browser PC / desktop yang tidak memiliki hardware GPS satelit.
  Future<Position?> _getIpFallbackPosition() async {
    // 1. Coba https://ipwho.is
    try {
      final res = await _httpClient
          .get(Uri.parse('https://ipwho.is'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map && data['success'] == true) {
          final lat = (data['latitude'] as num?)?.toDouble();
          final lon = (data['longitude'] as num?)?.toDouble();
          if (lat != null && lon != null) {
            return Position(
              latitude: lat,
              longitude: lon,
              timestamp: DateTime.now(),
              accuracy: 1000.0,
              altitude: 0.0,
              altitudeAccuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
            );
          }
        }
      }
    } catch (_) {}

    // 2. Coba https://ipapi.co/json/
    try {
      final res = await _httpClient
          .get(Uri.parse('https://ipapi.co/json/'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map) {
          final lat = (data['latitude'] as num?)?.toDouble();
          final lon = (data['longitude'] as num?)?.toDouble();
          if (lat != null && lon != null) {
            return Position(
              latitude: lat,
              longitude: lon,
              timestamp: DateTime.now(),
              accuracy: 1000.0,
              altitude: 0.0,
              altitudeAccuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
            );
          }
        }
      }
    } catch (_) {}

    return null;
  }

  /// Membuka halaman pengaturan aplikasi perangkat (berguna saat permission ditolak permanen)
  Future<bool> openAppSettings() async {
    if (kIsWeb) return false;
    try {
      return await Geolocator.openAppSettings();
    } catch (_) {
      return false;
    }
  }

  /// Membuka halaman pengaturan lokasi perangkat (berguna saat GPS mati)
  Future<bool> openLocationSettings() async {
    if (kIsWeb) return false;
    try {
      return await Geolocator.openLocationSettings();
    } catch (_) {
      return false;
    }
  }
}
