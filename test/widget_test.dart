import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/main.dart';
import 'package:frequencia_app/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test: loads empty state properly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();

    await tester.pumpWidget(FrequenciaApp(appState: appState));
    await tester.pumpAndSettle();

    expect(find.text('Frequência'), findsOneWidget);
    expect(find.text('Nenhuma disciplina adicionada'), findsOneWidget);
    expect(find.text('Adicionar disciplina'), findsOneWidget);
  });
}
