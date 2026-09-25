import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/models/absence_record.dart';
import 'package:frequencia_app/services/attendance_calculator.dart';

void main() {
  group('AttendanceCalculator Tests', () {
    test('1 tempo por aula: falta completa', () {
      final records = [
        AbsenceRecord(id: '1', date: DateTime(2026, 9, 20), missedPeriods: [1]),
        AbsenceRecord(id: '2', date: DateTime(2026, 9, 21), missedPeriods: [1]),
      ];
      final totalPeriods = AttendanceCalculator.calculateTotalMissedPeriods(records);
      final equivalent = AttendanceCalculator.calculateEquivalentAbsences(totalPeriods, 1);

      expect(totalPeriods, 2);
      expect(equivalent, 2.0);
      expect(AttendanceCalculator.formatAbsences(equivalent), '2');
    });

    test('2 tempos por aula: falta parcial e completa (exemplo do prompt)', () {
      // Prompt: "Se eu perder apenas um dos dois tempos: 1 tempo = 0,5 falta"
      // "Se eu perder os dois: 2 tempos = 1 falta"
      // "total_tempos_perdidos = 7, tempos_por_aula = 2 -> faltas = 3,5"
      final records = [
        AbsenceRecord(id: '1', date: DateTime(2026, 9, 20), missedPeriods: [1]), // 1 tempo
        AbsenceRecord(id: '2', date: DateTime(2026, 9, 21), missedPeriods: [1, 2]), // 2 tempos
        AbsenceRecord(id: '3', date: DateTime(2026, 9, 22), missedPeriods: [1, 2]), // 2 tempos
        AbsenceRecord(id: '4', date: DateTime(2026, 9, 23), missedPeriods: [2]), // 1 tempo
        AbsenceRecord(id: '5', date: DateTime(2026, 9, 24), missedPeriods: [1]), // 1 tempo
      ];
      // Total periods = 1 + 2 + 2 + 1 + 1 = 7
      final totalPeriods = AttendanceCalculator.calculateTotalMissedPeriods(records);
      final equivalent = AttendanceCalculator.calculateEquivalentAbsences(totalPeriods, 2);

      expect(totalPeriods, 7);
      expect(equivalent, 3.5);
      expect(AttendanceCalculator.formatAbsences(equivalent), '3,5');
    });

    test('3 tempos por aula: falta parcial (1 ou 2 tempos) e completa', () {
      // Prompt:
      // 1 tempo perdido = 0.333... falta
      // 2 tempos = 0.666... falta
      // 3 tempos = 1 falta
      final partial1 = AttendanceCalculator.calculateEquivalentAbsences(1, 3);
      expect(partial1, closeTo(1 / 3, 0.0001));
      expect(AttendanceCalculator.formatAbsences(partial1), '0,33');

      final partial2 = AttendanceCalculator.calculateEquivalentAbsences(2, 3);
      expect(partial2, closeTo(2 / 3, 0.0001));
      expect(AttendanceCalculator.formatAbsences(partial2), '0,67');

      final full = AttendanceCalculator.calculateEquivalentAbsences(3, 3);
      expect(full, 1.0);
      expect(AttendanceCalculator.formatAbsences(full), '1');
    });

    test('Cálculo de percentual de frequência e limites', () {
      // 4 faltas acumuladas em 30 aulas = (26 / 30) = 86.67%
      final pct30 = AttendanceCalculator.calculateFrequencyPercentage(
        equivalentAbsences: 4.0,
        totalExpectedClasses: 30,
      );
      expect(pct30.round(), 87);

      // 4 faltas em 60 aulas (padrão 15 limite * 4) = 56/60 = 93.3%
      final pct60 = AttendanceCalculator.calculateFrequencyPercentage(
        equivalentAbsences: 4.0,
        totalExpectedClasses: 60,
      );
      expect(pct60, closeTo(93.33, 0.1));

      // 0 faltas -> 100%
      final pctZero = AttendanceCalculator.calculateFrequencyPercentage(
        equivalentAbsences: 0.0,
        totalExpectedClasses: 60,
      );
      expect(pctZero, 100.0);

      // Faltas acima do total de aulas não deve passar de 0%
      final pctOver = AttendanceCalculator.calculateFrequencyPercentage(
        equivalentAbsences: 70.0,
        totalExpectedClasses: 60,
      );
      expect(pctOver, 0.0);
    });

    test('Status de saúde da frequência: seguro, atenção, atingido e estourado', () {
      const limit = 15.0;

      // 4 faltas de 15 = 26.6% -> Seguro (< 70%)
      expect(
        AttendanceCalculator.getStatus(equivalentAbsences: 4.0, limit: limit),
        AttendanceHealthStatus.safe,
      );

      // 11 faltas de 15 = 73.3% -> Atenção (>= 70%)
      expect(
        AttendanceCalculator.getStatus(equivalentAbsences: 11.0, limit: limit),
        AttendanceHealthStatus.warning,
      );

      // 15 faltas de 15 = 100% -> Limite atingido
      expect(
        AttendanceCalculator.getStatus(equivalentAbsences: 15.0, limit: limit),
        AttendanceHealthStatus.reached,
      );

      // 15.5 faltas de 15 -> Limite excedido
      expect(
        AttendanceCalculator.getStatus(equivalentAbsences: 15.5, limit: limit),
        AttendanceHealthStatus.exceeded,
      );
    });

    test('Cálculo de faltas e tempos restantes', () {
      const limit = 15.0;
      const periodsPerClass = 2; // total allowed periods = 30
      final totalMissedPeriods = 7; // 3.5 faltas
      final equivalent = AttendanceCalculator.calculateEquivalentAbsences(totalMissedPeriods, periodsPerClass);

      final remainingAbsences = AttendanceCalculator.calculateRemainingAbsences(limit, equivalent);
      final remainingPeriods = AttendanceCalculator.calculateRemainingPeriods(limit, periodsPerClass, totalMissedPeriods);

      expect(remainingAbsences, 11.5);
      expect(remainingPeriods, 23); // 30 - 7 = 23 tempos restantes
    });
  });
}
