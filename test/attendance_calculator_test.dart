import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/models/absence_record.dart';
import 'package:frequencia_app/models/discipline.dart';
import 'package:frequencia_app/services/attendance_calculator.dart';

void main() {
  group('AttendanceCalculator', () {
    test('cada tempo perdido conta uma falta', () {
      final d = Discipline(
        id: 'bd',
        name: 'Banco de Dados',
        iconKey: 'database',
        periodsPerClass: 3,
        absenceLimit: 15,
        absences: [
          AbsenceRecord(id: '1', date: DateTime(2026, 9, 20), missedPeriods: [1, 2, 3]),
          AbsenceRecord(id: '2', date: DateTime(2026, 9, 27), missedPeriods: [2, 3]),
        ],
      );
      expect(d.totalMissedPeriods, 5);
    });

    test('dias que ainda dá pra faltar', () {
      // 15 faltas com 3 tempos por dia = 5 dias
      expect(AttendanceCalculator.remainingDays(15, 0, 3), 5);
      expect(AttendanceCalculator.remainingDays(15, 3, 3), 4);
      expect(AttendanceCalculator.remainingDays(15, 5, 3), 3);
      expect(AttendanceCalculator.remainingDays(15, 14, 3), 0);
      expect(AttendanceCalculator.remainingDays(15, 18, 3), 0);
      expect(AttendanceCalculator.remainingDays(10, 3, 1), 7);
    });

    test('status pelo limite', () {
      AttendanceHealthStatus s(int a) => AttendanceCalculator.getStatus(absences: a, limit: 10);
      expect(s(0), AttendanceHealthStatus.safe);
      expect(s(6), AttendanceHealthStatus.safe);
      expect(s(7), AttendanceHealthStatus.warning);
      expect(s(10), AttendanceHealthStatus.reached);
      expect(s(11), AttendanceHealthStatus.exceeded);
    });

    test('frequência estimada', () {
      expect(AttendanceCalculator.frequencyPercentage(absences: 0, totalPeriods: 60), 100.0);
      expect(AttendanceCalculator.frequencyPercentage(absences: 15, totalPeriods: 60), 75.0);
      expect(AttendanceCalculator.frequencyPercentage(absences: 80, totalPeriods: 60), 0.0);
      expect(AttendanceCalculator.frequencyPercentage(absences: 3, totalPeriods: 0), 100.0);
    });

    test('textos', () {
      expect(AttendanceCalculator.faltas(1), '1 falta');
      expect(AttendanceCalculator.faltas(3), '3 faltas');
      expect(AttendanceCalculator.dias(1), '1 dia');
      expect(AttendanceCalculator.formatPeriodsDescription([1, 2, 3], 3), 'Aula inteira');
      expect(AttendanceCalculator.formatPeriodsDescription([2], 3), '2º tempo');
      expect(AttendanceCalculator.formatPeriodsDescription([3, 1], 3), '1º e 3º tempos');
      expect(AttendanceCalculator.formatPeriodsDescription([1, 2, 4], 4), '1º, 2º, 4º tempos');
    });
  });
}
