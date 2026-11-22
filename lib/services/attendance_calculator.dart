enum AttendanceHealthStatus {
  safe,
  warning,
  reached,
  exceeded,
}

class AttendanceCalculator {
  static int remaining(int limit, int missed) => limit - missed;

  static double frequencyPercentage({
    required int missed,
    required int totalClasses,
  }) {
    if (totalClasses <= 0) return 100.0;
    final pct = (totalClasses - missed) / totalClasses * 100.0;
    return pct.clamp(0.0, 100.0);
  }

  static AttendanceHealthStatus getStatus({
    required int missed,
    required int limit,
  }) {
    if (limit <= 0) return AttendanceHealthStatus.safe;
    if (missed > limit) return AttendanceHealthStatus.exceeded;
    if (missed == limit) return AttendanceHealthStatus.reached;
    if (missed / limit >= 0.70) return AttendanceHealthStatus.warning;
    return AttendanceHealthStatus.safe;
  }

  // pra faculdade que conta uma falta por tempo de aula: 15 faltas com 3 tempos por dia = 5 dias.
  // arredonda pra baixo pra não passar do limite
  static int daysFromPeriods(int periodLimit, int periodsPerDay) {
    if (periodLimit <= 0 || periodsPerDay <= 0) return 0;
    return periodLimit ~/ periodsPerDay;
  }

  static String dias(int n) => n == 1 ? '1 dia' : '$n dias';
}
