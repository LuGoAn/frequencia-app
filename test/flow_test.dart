import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/main.dart';
import 'package:frequencia_app/models/absence_record.dart';
import 'package:frequencia_app/models/discipline.dart';
import 'package:frequencia_app/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('cadastra disciplina e registra falta de 1 tempo', (tester) async {
    final appState = AppState();
    await appState.init();

    final discipline = Discipline(
      id: 'poo_1',
      name: 'Programação Orientada a Objeto',
      iconKey: 'code',
      periodsPerClass: 2,
      absenceLimit: 15.0,
    );
    await appState.addDiscipline(discipline);

    await tester.pumpWidget(FrequenciaApp(appState: appState));
    await tester.pumpAndSettle();

    expect(find.text('Programação Orientada a Objeto'), findsOneWidget);
    expect(find.text('2 tempos por aula'), findsOneWidget);

    await tester.tap(find.text('Programação Orientada a Objeto'));
    await tester.pumpAndSettle();

    expect(find.text('2 tempos por aula, limite de 15 faltas'), findsOneWidget);
    expect(find.text('Registrar falta'), findsOneWidget);
    expect(find.text('Nenhuma falta registrada ainda.'), findsOneWidget);

    final absence = AbsenceRecord(
      id: 'abs_1',
      date: DateTime.now(),
      missedPeriods: [1],
    );
    await appState.addAbsence('poo_1', absence);
    await tester.pumpAndSettle();

    expect(find.textContaining('0,5'), findsWidgets);
    expect(find.text('1º tempo'), findsOneWidget);
    expect(find.text('0,5 falta'), findsOneWidget);

    expect(appState.themeMode, ThemeMode.light);
    await appState.toggleTheme();
    expect(appState.themeMode, ThemeMode.dark);
  });
}
