import '../models/absence_record.dart';

enum AttendanceHealthStatus {
  safe,
  warning,
  reached,
  exceeded,
}

class AttendanceCalculator {
  static int calculateTotalMissedPeriods(List<AbsenceRecord> records) {
    return records.fold(0, (sum, record) => sum + record.missedPeriods.length);
  }

  static double calculateEquivalentAbsences(int totalMissedPeriods, int periodsPerClass) {
    if (periodsPerClass <= 0) return 0.0;
    return totalMissedPeriods / periodsPerClass;
  }

  static double calculateRemainingAbsences(double limit, double equivalentAbsences) {
    return limit - equivalentAbsences;
  }

  static int calculateRemainingPeriods(double limit, int periodsPerClass, int totalMissedPeriods) {
    final totalAllowedPeriods = (limit * periodsPerClass).round();
    return totalAllowedPeriods - totalMissedPeriods;
  }

  static double calculateFrequencyPercentage({
    required double equivalentAbsences,
    required int totalExpectedClasses,
  }) {
    if (totalExpectedClasses <= 0) return 100.0;
    final remainingClasses = totalExpectedClasses - equivalentAbsences;
    final pct = (remainingClasses / totalExpectedClasses) * 100.0;
    return pct.clamp(0.0, 100.0);
  }

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

  // 0,5 falta e 1,5 falta: plural só a partir de 2
  static String faltaWord(double value) =>
      value > 0 && value < 2 ? 'falta' : 'faltas';

  static String formatAbsences(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    final formattedOneDecimal = value.toStringAsFixed(1);
    if (double.parse(formattedOneDecimal) == value) {
      return formattedOneDecimal.replaceAll('.', ',');
    }
    final formattedTwoDecimals = value.toStringAsFixed(2);
    String clean = formattedTwoDecimals;
    if (clean.endsWith('0')) {
      clean = clean.substring(0, clean.length - 1);
    }
    return clean.replaceAll('.', ',');
  }

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

    return '${sorted.map((p) => '$pº').join(', ')} tempos';
  }
}
