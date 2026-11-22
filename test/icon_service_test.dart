import 'package:flutter_test/flutter_test.dart';
import 'package:frequencia_app/services/icon_service.dart';

void main() {
  test('sugere ícone pelo nome', () {
    final cases = {
      'Banco de Dados II': 'storage',
      'Estruturas de Dados': 'account_tree',
      'Inteligência Artificial': 'psychology',
      'Anatomia Humana II': 'accessibility_new',
      'Engenharia de Software': 'code',
      'Direito Penal I': 'policy',
      'Direito Civil': 'gavel',
      'Farmacologia': 'medication',
      'Psicologia do Desenvolvimento': 'psychology_alt',
      'Contabilidade Geral': 'receipt_long',
      'História do Brasil': 'history_edu',
      'Cálculo II': 'functions',
      'Concreto Armado': 'construction',
      'Qualquer Coisa': 'bookmark',
    };
    cases.forEach((name, key) => expect(IconService.suggestIcon(name), key, reason: name));
  });

  test('todo ícone tem categoria conhecida e chave única', () {
    final keys = IconService.allIcons.map((i) => i.key).toList();
    expect(keys.toSet().length, keys.length);
    for (final i in IconService.allIcons) {
      expect(IconService.categories, contains(i.category));
    }
  });
}
