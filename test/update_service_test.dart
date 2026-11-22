import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/main.dart';
import 'package:frequencia_app/services/update_service.dart';
import 'package:frequencia_app/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeUpdates extends UpdateService {
  @override
  Future<AppUpdate?> check() async =>
      const AppUpdate(version: '1.3.0', downloadUrl: 'https://example.com/frequencia-1.3.0.apk');
}

void main() {
  test('compara versões', () {
    expect(UpdateService.isNewer('v1.2.1', '1.2.0'), isTrue);
    expect(UpdateService.isNewer('v1.10.0', '1.9.3'), isTrue);
    expect(UpdateService.isNewer('v2.0.0', '1.99.99'), isTrue);
    expect(UpdateService.isNewer('v1.2.0', '1.2.0'), isFalse);
    expect(UpdateService.isNewer('v1.1.0', '1.2.0'), isFalse);
    expect(UpdateService.isNewer('1.2.0+5', '1.2.0'), isFalse);
  });

  test('pega o APK da release', () {
    final data = {
      'tag_name': 'v1.3.0',
      'html_url': 'https://github.com/x/releases/tag/v1.3.0',
      'assets': [
        {'name': 'notas.txt', 'browser_download_url': 'https://x/notas.txt'},
        {'name': 'frequencia-1.3.0.apk', 'browser_download_url': 'https://x/frequencia-1.3.0.apk'},
      ],
    };
    final update = UpdateService.parseRelease(data, '1.2.0');
    expect(update?.version, '1.3.0');
    expect(update?.downloadUrl, 'https://x/frequencia-1.3.0.apk');

    expect(UpdateService.parseRelease(data, '1.3.0'), isNull);
    expect(
      UpdateService.parseRelease({'tag_name': 'v1.3.0', 'html_url': 'https://x/tag'}, '1.2.0')?.downloadUrl,
      'https://x/tag',
    );
  });

  testWidgets('mostra o aviso e some ao fechar', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState(updateService: _FakeUpdates());
    await appState.init();

    await tester.pumpWidget(FrequenciaApp(appState: appState));
    await appState.checkForUpdate();
    await tester.pumpAndSettle();
    expect(find.text('Versão 1.3.0 disponível'), findsOneWidget);

    await tester.tap(find.text('Agora não'));
    await tester.pumpAndSettle();
    expect(find.text('Versão 1.3.0 disponível'), findsNothing);

    // abrindo de novo, a mesma versão não aparece
    final again = AppState(updateService: _FakeUpdates());
    await again.init();
    await again.checkForUpdate();
    expect(again.availableUpdate, isNull);
  });
}
