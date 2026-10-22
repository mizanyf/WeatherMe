import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/services/weather_controller.dart';
import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import 'weather_icon.dart';

class WeatherCalendar extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeatherCalendar({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<WeatherCalendar> createState() => _WeatherCalendarState();
}

class _WeatherCalendarState extends State<WeatherCalendar> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  // Indonesian month names
  static const List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // Indonesian weekday abbreviations (Monday to Sunday)
  static const List<String> _weekdays = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
  }

  @override
  void didUpdateWidget(WeatherCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate.year != widget.initialDate.year ||
        oldWidget.initialDate.month != widget.initialDate.month ||
        oldWidget.initialDate.day != widget.initialDate.day) {
      setState(() {
        _selectedDate = widget.initialDate;
        _displayedMonth = DateTime(
          widget.initialDate.year,
          widget.initialDate.month,
        );
      });
    }
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
  }

  /// Menentukan icon cuaca untuk tanggal di kalender.
  /// Sesuai instruksi: hanya tanggal dalam jendela 7 hari ke belakang dan 7 hari ke depan dari hari ini yang memiliki icon.
  /// Selain itu (terlalu lampau atau terlalu jauh ke depan), prediksinya hilang/belum muncul (return null).
  WeatherConditionType? _getConditionForDate(DateTime date) {
    final forecast = WeatherController.instance.getForecastForDate(date);
    if (!forecast.isAvailable) {
      return null;
    }
    return forecast.conditionType;
  }

  @override
  Widget build(BuildContext context) {
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;
    final monthName = _monthNames[month - 1];

    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    // 1 = Monday, 7 = Sunday in DateTime.weekday
    final firstDayWeekday = DateTime(year, month, 1).weekday; // 1 to 7

    final previousMonthDays = DateUtils.getDaysInMonth(
      month == 1 ? year - 1 : year,
      month == 1 ? 12 : month - 1,
    );

    // Number of days from previous month to show (1 = Monday means 0 offset)
    final leadingDays = firstDayWeekday - 1;

    final totalGridCells = (leadingDays + daysInMonth <= 35) ? 35 : 42;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: AppColors.glassBorder, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F7FC), // Soft Ice Sky #48CBE8 tint
            Color(0xFFF0FDFE), // Frosted Pure White-Blue
            Color(0xFFBAE6FD), // Ambient Blue Accent
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigmaLight,
            sigmaY: AppColors.glassBlurSigmaLight,
          ),
          child: Stack(
            children: [
              // Soft ambient depth circle in the corner
              Positioned(
                right: -30,
                top: -25,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
              ),

              // Calendar content
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 18.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Month/Year header and navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Icon + Month Year
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF48CBE8), // AppColors.primary
                                    Color(0xFF0284C7), // AppColors.secondary
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0284C7)
                                        .withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                        Text(
                          '$monthName $year',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),

                    // Prev / Next buttons
                    Row(
                      children: [
                        _buildNavButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: _goToPreviousMonth,
                        ),
                        const SizedBox(width: 4),
                        _buildNavButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: _goToNextMonth,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Weekday Labels Row
                Row(
                  children: _weekdays.map((day) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedText,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 10),

                // Date Grid Rows
                Column(
                  children: List.generate((totalGridCells / 7).ceil(), (
                    rowIndex,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: List.generate(7, (colIndex) {
                          final cellIndex = rowIndex * 7 + colIndex;

                          if (cellIndex < leadingDays) {
                            // Day from previous month
                            final prevDayNumber =
                                previousMonthDays -
                                (leadingDays - cellIndex - 1);
                            return Expanded(
                              child: Center(
                                child: Text(
                                  '$prevDayNumber',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mutedText.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (cellIndex < leadingDays + daysInMonth) {
                            // Day in current month
                            final dayNumber = cellIndex - leadingDays + 1;
                            final currentDate = DateTime(
                              year,
                              month,
                              dayNumber,
                            );
                            final isSelected =
                                _selectedDate.year == currentDate.year &&
                                _selectedDate.month == currentDate.month &&
                                _selectedDate.day == currentDate.day;

                            final now = DateTime.now();
                            final isToday =
                                currentDate.year == now.year &&
                                currentDate.month == now.month &&
                                currentDate.day == now.day;

                            final condition = _getConditionForDate(currentDate);

                            return Expanded(
                              child: _buildDateCell(
                                date: currentDate,
                                dayNumber: dayNumber,
                                isSelected: isSelected,
                                isToday: isToday,
                                condition: condition,
                              ),
                            );
                          } else {
                            // Day from next month
                            final nextDayNumber =
                                cellIndex - (leadingDays + daysInMonth) + 1;
                            return Expanded(
                              child: Center(
                                child: Text(
                                  '$nextDayNumber',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mutedText.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.70),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: AppColors.neutral),
        ),
      ),
    );
  }

  Widget _buildDateCell({
    required DateTime date,
    required int dayNumber,
    required bool isSelected,
    required bool isToday,
    required WeatherConditionType? condition,
  }) {
    return InkWell(
      onTap: () => _selectDate(date),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF48CBE8), Color(0xFF0284C7)],
                )
              : null,
          color: isSelected
              ? null
              : (isToday
                    ? Colors.white.withValues(alpha: 0.65)
                    : Colors.transparent),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.40),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : (isToday
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                color: isSelected
                    ? Colors.white
                    : (condition != null
                        ? AppColors.neutral
                        : AppColors.mutedText.withValues(alpha: 0.50)),
              ),
            ),
            const SizedBox(height: 2),
            if (condition != null)
              WeatherIcon(
                conditionType: condition,
                size: 13,
                color: isSelected ? Colors.white : null,
              )
            else
              const SizedBox(height: 13),
          ],
        ),
      ),
    );
  }
}
