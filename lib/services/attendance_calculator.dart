import 'dart:math';
import '../models/absence_record.dart';

enum AttendanceHealthStatus {
  safe, // Absence is low (< 70% of limit)
  warning, // Approaching limit (>= 70% and < 100%)
  reached, // Exactly hit the limit (100%)
  exceeded, // Exceeded the limit (> 100%)
}

class AttendanceCalculator {
  /// Calculates the total count of missed periods across all absence records.
  static int calculateTotalMissedPeriods(List<AbsenceRecord> records) {
    return records.fold(0, (sum, record) => sum + record.missedPeriods.length);
  }

  /// Calculates equivalent absences given total missed periods and periods per class.
  /// Example: 7 missed periods with 2 periods/class = 3.5 faltas.
  static double calculateEquivalentAbsences(int totalMissedPeriods, int periodsPerClass) {
    if (periodsPerClass <= 0) return 0.0;
    return totalMissedPeriods / periodsPerClass;
  }

  /// Calculates the remaining absence allowance.
  /// Can be negative if the student has exceeded the limit.
  static double calculateRemainingAbsences(double limit, double equivalentAbsences) {
    return limit - equivalentAbsences;
  }

  /// Calculates remaining periods allowed before exceeding limit.
  static int calculateRemainingPeriods(double limit, int periodsPerClass, int totalMissedPeriods) {
    final totalAllowedPeriods = (limit * periodsPerClass).round();
    return totalAllowedPeriods - totalMissedPeriods;
  }

  /// Calculates the attendance percentage.
  /// [equivalentAbsences]: accumulated absences (float)
  /// [totalExpectedClasses]: total classes planned in the term/semester
  static double calculateFrequencyPercentage({
    required double equivalentAbsences,
    required int totalExpectedClasses,
  }) {
    if (totalExpectedClasses <= 0) return 100.0;
    final remainingClasses = totalExpectedClasses - equivalentAbsences;
    final pct = (remainingClasses / totalExpectedClasses) * 100.0;
    return pct.clamp(0.0, 100.0);
  }

  /// Determines the health status of a discipline's attendance.
  static AttendanceHealthStatus getStatus({
    required double equivalentAbsences,
    required double limit,
  }) {
    if (limit <= 0) return AttendanceHealthStatus.safe;
    if (equivalentAbsences > limit) {
      return AttendanceHealthStatus.exceeded;
    }
    if ((equivalentAbsences - limit).abs() < 0.0001) {
      return AttendanceHealthStatus.reached;
    }
    final ratio = equivalentAbsences / limit;
    if (ratio >= 0.70) {
      return AttendanceHealthStatus.warning;
    }
    return AttendanceHealthStatus.safe;
  }

  /// Cleanly formats absence numbers without unnecessary trailing zeros.
  /// 4.0 -> "4"
  /// 3.5 -> "3,5"
  /// 0.333333 -> "0,33"
  /// 0.666667 -> "0,67"
  static String formatAbsences(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    // Check if it's a clean tenth (.5, .2, etc.)
    final formattedOneDecimal = value.toStringAsFixed(1);
    if (double.parse(formattedOneDecimal) == value) {
      return formattedOneDecimal.replaceAll('.', ',');
    }
    // Otherwise 2 decimals rounded
    final formattedTwoDecimals = value.toStringAsFixed(2);
    // Remove trailing zero if applicable (e.g. 3.50 -> 3.5)
    String clean = formattedTwoDecimals;
    if (clean.endsWith('0')) {
      clean = clean.substring(0, clean.length - 1);
    }
    return clean.replaceAll('.', ',');
  }

  /// Formats human-readable representation of missed periods.
  /// e.g. [1] -> "1º tempo"
  /// e.g. [1, 2] with total 2 -> "2 tempos (aula toda)"
  /// e.g. [1, 2] with total 3 -> "1º e 2º tempos"
  static String formatPeriodsDescription(List<int> periods, int periodsPerClass) {
    if (periods.isEmpty) return 'Nenhum tempo';
    
    final sorted = List<int>.from(periods)..sort();
    if (sorted.length == periodsPerClass && periodsPerClass > 1) {
      return '$periodsPerClass tempos (aula inteira)';
    }

    if (sorted.length == 1) {
      return '${sorted.first}º tempo';
    }

    if (sorted.length == 2) {
      return '${sorted[0]}º e ${sorted[1]}º tempos';
    }

    return sorted.map((p) => '${p}º').join(', ') + ' tempos';
  }
}
