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

  testWidgets('End-to-end flow: Add discipline and register partial absence', (tester) async {
    final appState = AppState();
    await appState.init();

    // 1. Add a discipline directly to state or via UI
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

    // Verify card is rendered on home screen
    expect(find.text('Programação Orientada a Objeto'), findsOneWidget);
    expect(find.text(' / 15 faltas'), findsOneWidget);

    // 2. Tap card to view details
    await tester.tap(find.text('Programação Orientada a Objeto'));
    await tester.pumpAndSettle();

    expect(find.text('2 tempos por aula'), findsOneWidget);
    expect(find.text('Registrar falta'), findsOneWidget);
    expect(find.text('Frequência perfeita!'), findsOneWidget);

    // 3. Register a partial absence (1 tempo out of 2)
    final absence = AbsenceRecord(
      id: 'abs_1',
      date: DateTime.now(),
      missedPeriods: [1],
    );
    await appState.addAbsence('poo_1', absence);
    await tester.pumpAndSettle();

    // 1 tempo of 2 = 0.5 falta
    expect(find.textContaining('0,5'), findsWidgets);
    expect(find.text('1º tempo'), findsOneWidget);
    expect(find.text('0,5 faltas equivalentes'), findsOneWidget);

    // 4. Test theme toggle
    expect(appState.themeMode, ThemeMode.light);
    await appState.toggleTheme();
    expect(appState.themeMode, ThemeMode.dark);
  });
}
