import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/models/absence_record.dart';
import 'package:frequencia_app/models/discipline.dart';
import 'package:frequencia_app/services/attendance_calculator.dart';

void main() {
  group('AttendanceCalculator', () {
    test('cada registro conta um dia', () {
      final d = Discipline(
        id: 'bd',
        name: 'Banco de Dados',
        iconKey: 'storage',
        absenceLimit: 5,
        absences: [
          AbsenceRecord(id: '1', date: DateTime(2026, 9, 20)),
          AbsenceRecord(id: '2', date: DateTime(2026, 9, 27)),
        ],
      );
      expect(d.missedDays, 2);
      expect(AttendanceCalculator.remaining(d.absenceLimit, d.missedDays), 3);
    });

    test('converte limite em tempos pra dias', () {
      expect(AttendanceCalculator.daysFromPeriods(15, 3), 5);
      expect(AttendanceCalculator.daysFromPeriods(20, 2), 10);
      expect(AttendanceCalculator.daysFromPeriods(16, 3), 5);
      expect(AttendanceCalculator.daysFromPeriods(2, 3), 0);
      expect(AttendanceCalculator.daysFromPeriods(10, 0), 0);
    });

    test('status pelo limite', () {
      AttendanceHealthStatus s(int m) => AttendanceCalculator.getStatus(missed: m, limit: 10);
      expect(s(0), AttendanceHealthStatus.safe);
      expect(s(6), AttendanceHealthStatus.safe);
      expect(s(7), AttendanceHealthStatus.warning);
      expect(s(10), AttendanceHealthStatus.reached);
      expect(s(11), AttendanceHealthStatus.exceeded);
    });

    test('frequência estimada', () {
      expect(AttendanceCalculator.frequencyPercentage(missed: 0, totalClasses: 20), 100.0);
      expect(AttendanceCalculator.frequencyPercentage(missed: 5, totalClasses: 20), 75.0);
      expect(AttendanceCalculator.frequencyPercentage(missed: 30, totalClasses: 20), 0.0);
      expect(AttendanceCalculator.frequencyPercentage(missed: 3, totalClasses: 0), 100.0);
    });

    test('dados antigos com limite fracionado e tempos ainda carregam', () {
      final d = Discipline.fromJson({
        'id': 'x',
        'name': 'Cálculo II',
        'iconKey': 'functions',
        'periodsPerClass': 2,
        'absenceLimit': 7.5,
        'absences': [
          {'id': 'a', 'date': '2026-09-01T00:00:00.000', 'missedPeriods': [1, 2]},
        ],
      });
      expect(d.absenceLimit, 8);
      expect(d.missedDays, 1);
    });
  });
}
