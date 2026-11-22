import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/main.dart';
import 'package:frequencia_app/models/discipline.dart';
import 'package:frequencia_app/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('cadastra disciplina e registra falta', (tester) async {
    final appState = AppState();
    await appState.init();

    await appState.addDiscipline(Discipline(
      id: 'poo_1',
      name: 'Programação Orientada a Objeto',
      iconKey: 'code',
      absenceLimit: 5,
    ));

    await tester.pumpWidget(FrequenciaApp(appState: appState));
    await tester.pumpAndSettle();

    expect(find.text('Programação Orientada a Objeto'), findsOneWidget);
    expect(find.text('Dá pra faltar mais 5 dias'), findsOneWidget);

    await tester.tap(find.text('Programação Orientada a Objeto'));
    await tester.pumpAndSettle();

    expect(find.text('Pode faltar até 5 dias'), findsOneWidget);
    expect(find.text('Nenhuma falta registrada ainda.'), findsOneWidget);

    await tester.tap(find.text('Registrar falta'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Registrar falta').last);
    await tester.pumpAndSettle();

    expect(appState.disciplines.single.missedDays, 1);
    expect(find.text('Dá pra faltar mais 4 dias.'), findsOneWidget);

    // mesmo dia de novo não pode
    await tester.tap(find.text('Registrar falta'));
    await tester.pumpAndSettle();
    expect(find.text('Já tem uma falta registrada nesse dia.'), findsOneWidget);

    expect(appState.themeMode, ThemeMode.light);
    await appState.toggleTheme();
    expect(appState.themeMode, ThemeMode.dark);
  });

  testWidgets('calcula os dias a partir do limite em tempos', (tester) async {
    final appState = AppState();
    await appState.init();

    await tester.pumpWidget(FrequenciaApp(appState: appState));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adicionar disciplina'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Não sabe quantos dias?'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Limite no sistema'), '15');
    await tester.enterText(find.widgetWithText(TextField, 'Tempos num dia de aula'), '3');
    await tester.pump();
    expect(find.text('Dá pra faltar 5 dias.'), findsOneWidget);

    await tester.tap(find.text('Usar 5 dias'));
    await tester.pumpAndSettle();
    final texts = tester.widgetList<EditableText>(find.byType(EditableText)).map((e) => e.controller.text);
    expect(texts, contains('5'));
  });
}
