import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

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

  /// Helper to determine weather icon for a date
  WeatherConditionType? _getConditionForDate(DateTime date) {
    // Only return mock forecast indicators for October 2026
    if (date.year == 2026 && date.month == 10) {
      if (date.day >= 7 && date.day <= 13) {
        if (date.day == 9) return WeatherConditionType.cloudy;
        if (date.day == 10) return WeatherConditionType.rainy;
        return WeatherConditionType.sunny;
      }
      if (date.day >= 14 && date.day <= 20) {
        if (date.day == 15 || date.day == 20) {
          return WeatherConditionType.cloudy;
        }
        return WeatherConditionType.sunny;
      }
      if (date.day >= 21 && date.day <= 27) {
        final mock = CalendarDayForecast.mockOctober[date.day];
        return mock?.conditionType ?? WeatherConditionType.sunny;
      }
      if (date.day >= 28 && date.day <= 31) {
        if (date.day == 29) return WeatherConditionType.partlyCloudy;
        if (date.day == 30) return WeatherConditionType.rainy;
        if (date.day == 31) return WeatherConditionType.cloudy;
        return WeatherConditionType.sunny;
      }
    }
    return null;
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
      padding: const EdgeInsets.fromLTRB(16.0, 18.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
                      color: AppColors.tertiary.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: AppColors.secondary,
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
            children: List.generate((totalGridCells / 7).ceil(), (rowIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: List.generate(7, (colIndex) {
                    final cellIndex = rowIndex * 7 + colIndex;

                    if (cellIndex < leadingDays) {
                      // Day from previous month
                      final prevDayNumber =
                          previousMonthDays - (leadingDays - cellIndex - 1);
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
                      final currentDate = DateTime(year, month, dayNumber);
                      final isSelected =
                          _selectedDate.year == currentDate.year &&
                          _selectedDate.month == currentDate.month &&
                          _selectedDate.day == currentDate.day;

                      final isToday =
                          currentDate.year == 2026 &&
                          currentDate.month == 10 &&
                          currentDate.day == 21;

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
            color: AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 1.0),
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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: AppColors.secondary, width: 1.2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.45),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.neutral : AppColors.neutral,
              ),
            ),
            const SizedBox(height: 2),
            if (condition != null)
              _buildSmallWeatherIcon(condition, isSelected)
            else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallWeatherIcon(
    WeatherConditionType condition,
    bool isSelected,
  ) {
    final color = isSelected ? AppColors.neutral : AppColors.secondary;

    switch (condition) {
      case WeatherConditionType.sunny:
        return Icon(
          Icons.wb_sunny_rounded,
          size: 11,
          color: isSelected ? AppColors.neutral : AppColors.sunnyYellow,
        );
      case WeatherConditionType.partlyCloudy:
        return Icon(Icons.wb_cloudy_rounded, size: 11, color: color);
      case WeatherConditionType.cloudy:
        return Icon(Icons.cloud_rounded, size: 11, color: color);
      case WeatherConditionType.rainy:
        return Icon(Icons.grain_rounded, size: 11, color: color);
    }
  }
}
