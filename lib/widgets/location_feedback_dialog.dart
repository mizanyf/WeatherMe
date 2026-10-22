import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/services/location_service.dart';
import '../theme/app_colors.dart';

/// Dialog elegan dengan style Glassmorphic khas WeatherMe untuk menampilkan
/// status kegagalan izin/layanan GPS serta menyediakan opsi fallback ke pencarian manual.
class LocationFeedbackDialog extends StatelessWidget {
  final LocationResult result;
  final VoidCallback? onManualSearchSelected;
  final VoidCallback? onRetry;

  const LocationFeedbackDialog({
    super.key,
    required this.result,
    this.onManualSearchSelected,
    this.onRetry,
  });

  /// Menampilkan dialog penanganan lokasi dengan fallback manual
  static Future<void> show(
    BuildContext context, {
    required LocationResult result,
    VoidCallback? onManualSearchSelected,
    VoidCallback? onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LocationFeedbackDialog(
        result: result,
        onManualSearchSelected: onManualSearchSelected,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _getTitle();
    final description = _getDescription();
    final iconData = _getIcon();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          padding: const EdgeInsets.all(22.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: AppColors.glassBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.neutral.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFECACA),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  iconData,
                  size: 26,
                  color: const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Fallback: Tombol Cari Kota Manual
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onManualSearchSelected?.call();
                  },
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: const Text(
                    'Pilih / Cari Kota Manual',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Action spesifik sistem (Buka Pengaturan / Coba Lagi)
              if (!kIsWeb && result.status == LocationStatus.serviceDisabled) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      LocationService.instance.openLocationSettings();
                    },
                    icon: const Icon(Icons.location_on_rounded, size: 16),
                    label: const Text(
                      'Buka Pengaturan GPS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neutral,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ] else if (!kIsWeb &&
                  result.status == LocationStatus.permissionDeniedForever) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      LocationService.instance.openAppSettings();
                    },
                    icon: const Icon(Icons.settings_rounded, size: 16),
                    label: const Text(
                      'Buka Pengaturan Aplikasi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neutral,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ] else if (onRetry != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry?.call();
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text(
                      'Coba Lagi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neutral,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],

              // Tombol Batal/Tutup
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (result.status) {
      case LocationStatus.serviceDisabled:
        return 'Layanan Lokasi (GPS) Mati';
      case LocationStatus.permissionDenied:
        return 'Izin Lokasi Ditolak';
      case LocationStatus.permissionDeniedForever:
        return 'Izin Lokasi Ditolak Permanen';
      case LocationStatus.locationError:
      case LocationStatus.success:
        return 'Gagal Memperoleh Lokasi';
    }
  }

  String _getDescription() {
    if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
      return result.errorMessage!;
    }
    switch (result.status) {
      case LocationStatus.serviceDisabled:
        return 'GPS pada perangkat Anda belum aktif. Aktifkan GPS atau pilih kota secara manual.';
      case LocationStatus.permissionDenied:
        return 'WeatherMe memerlukan izin lokasi untuk mendeteksi cuaca setempat secara otomatis.';
      case LocationStatus.permissionDeniedForever:
        return 'Izin lokasi dinonaktifkan secara permanen. Buka Pengaturan Aplikasi untuk mengizinkannya, atau pilih kota secara manual.';
      case LocationStatus.locationError:
      case LocationStatus.success:
        return 'Terjadi kendala saat membaca koordinat GPS perangkat.';
    }
  }

  IconData _getIcon() {
    switch (result.status) {
      case LocationStatus.serviceDisabled:
        return Icons.location_off_rounded;
      case LocationStatus.permissionDenied:
      case LocationStatus.permissionDeniedForever:
        return Icons.lock_outline_rounded;
      case LocationStatus.locationError:
      case LocationStatus.success:
        return Icons.warning_amber_rounded;
    }
  }
}
