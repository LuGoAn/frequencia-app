import 'package:flutter/material.dart';
import '../models/discipline.dart';
import '../services/attendance_calculator.dart';
import '../services/icon_service.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

class DisciplineCard extends StatelessWidget {
  final Discipline discipline;
  final VoidCallback onTap;

  const DisciplineCard({
    super.key,
    required this.discipline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final equivalent = discipline.equivalentAbsences;
    final limit = discipline.absenceLimit;
    final status = AttendanceCalculator.getStatus(
      equivalentAbsences: equivalent,
      limit: limit,
    );
    final frequency = AttendanceCalculator.calculateFrequencyPercentage(
      equivalentAbsences: equivalent,
      totalExpectedClasses: discipline.totalExpectedClasses,
    );

    // Calculate progress ratio (absences consumed vs limit)
    final progress = limit > 0 ? (equivalent / limit).clamp(0.0, 1.0) : 0.0;

    // Remaining absences
    final remaining = AttendanceCalculator.calculateRemainingAbsences(limit, equivalent);

    // Dynamic bar color based on status
    Color indicatorColor;
    switch (status) {
      case AttendanceHealthStatus.safe:
        indicatorColor = isDark ? AppColors.darkSafeGreen : AppColors.safeGreen;
        break;
      case AttendanceHealthStatus.warning:
        indicatorColor = isDark ? AppColors.darkWarningAmber : AppColors.warningAmber;
        break;
      case AttendanceHealthStatus.reached:
      case AttendanceHealthStatus.exceeded:
        indicatorColor = isDark ? AppColors.darkAlertRose : AppColors.alertRose;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Circular icon capsule + Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceElevated
                            : AppColors.primaryContainer.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.primary.withOpacity(0.12),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        IconService.getIcon(discipline.iconKey),
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                        size: 22,
                      ),
                    ),
                    StatusBadge(status: status, compact: true),
                  ],
                ),
                const SizedBox(height: 18),

                // Course Name
                Text(
                  discipline.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Primary metric (Faltas acumuladas / Limite)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      AttendanceCalculator.formatAbsences(equivalent),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      ' / ${AttendanceCalculator.formatAbsences(limit)} faltas',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Subtle Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.lightBorder.withOpacity(0.7),
                    valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                  ),
                ),
                const SizedBox(height: 12),

                // Footer row: Frequency percentage and Remaining allowance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Frequência ${frequency.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    Text(
                      remaining > 0
                          ? 'Resta ${AttendanceCalculator.formatAbsences(remaining)}'
                          : remaining == 0
                              ? 'Limite esgotado'
                              : 'Excedeu ${AttendanceCalculator.formatAbsences(remaining.abs())}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: remaining < 0
                            ? (isDark ? AppColors.darkAlertRose : AppColors.alertRose)
                            : (isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
