enum AttendanceHealthStatus {
  safe,
  warning,
  reached,
  exceeded,
}

// Cada tempo perdido é uma falta inteira, igual no sistema da faculdade.
// Um dia de aula com 3 tempos = 3 faltas.
class AttendanceCalculator {
  static int remaining(int limit, int absences) => limit - absences;

  // dias inteiros que ainda dá pra faltar sem passar do limite
  static int remainingDays(int limit, int absences, int periodsPerClass) {
    final left = limit - absences;
    if (left <= 0 || periodsPerClass <= 0) return 0;
    return left ~/ periodsPerClass;
  }

  static double frequencyPercentage({
    required int absences,
    required int totalPeriods,
  }) {
    if (totalPeriods <= 0) return 100.0;
    final pct = (totalPeriods - absences) / totalPeriods * 100.0;
    return pct.clamp(0.0, 100.0);
  }

  static AttendanceHealthStatus getStatus({
    required int absences,
    required int limit,
  }) {
    if (limit <= 0) return AttendanceHealthStatus.safe;
    if (absences > limit) return AttendanceHealthStatus.exceeded;
    if (absences == limit) return AttendanceHealthStatus.reached;
    if (absences / limit >= 0.70) return AttendanceHealthStatus.warning;
    return AttendanceHealthStatus.safe;
  }

  static String faltas(int n) => n == 1 ? '1 falta' : '$n faltas';

  static String dias(int n) => n == 1 ? '1 dia' : '$n dias';

  static String formatPeriodsDescription(List<int> periods, int periodsPerClass) {
    if (periods.isEmpty) return 'Nenhum tempo';

    final sorted = List<int>.from(periods)..sort();
    if (sorted.length == periodsPerClass) return 'Aula inteira';
    if (sorted.length == 1) return '${sorted.first}º tempo';
    if (sorted.length == 2) return '${sorted[0]}º e ${sorted[1]}º tempos';
    return '${sorted.map((p) => '$pº').join(', ')} tempos';
  }
}
