import 'package:flutter/material.dart';

class DisciplineIconItem {
  final String key;
  final String label;
  final IconData icon;
  final String category;

  const DisciplineIconItem({
    required this.key,
    required this.label,
    required this.icon,
    required this.category,
  });
}

class IconService {
  static const List<DisciplineIconItem> allIcons = [
    // --- Tecnologia & Programação ---
    DisciplineIconItem(
      key: 'code',
      label: 'Código / Dev',
      icon: Icons.code_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'terminal',
      label: 'Terminal / Alta Performance',
      icon: Icons.terminal_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'laptop',
      label: 'Software / Computação',
      icon: Icons.laptop_chromebook_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'developer_mode',
      label: 'Frameworks / Web',
      icon: Icons.developer_mode_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'storage',
      label: 'Banco de Dados',
      icon: Icons.storage_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'memory',
      label: 'Arquitetura / Hardware',
      icon: Icons.memory_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'hub',
      label: 'Redes / Conexões',
      icon: Icons.hub_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'cloud',
      label: 'Cloud Computing',
      icon: Icons.cloud_outlined,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'smartphone',
      label: 'Mobile Coding',
      icon: Icons.phone_android_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'lock',
      label: 'Segurança da Informação',
      icon: Icons.lock_outline_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'devices',
      label: 'Concorrente / Distribuída',
      icon: Icons.devices_rounded,
      category: 'Tecnologia',
    ),
    DisciplineIconItem(
      key: 'account_tree',
      label: 'Estrutura de Dados',
      icon: Icons.account_tree_rounded,
      category: 'Tecnologia',
    ),

    // --- Inteligência Artificial & Robótica ---
    DisciplineIconItem(
      key: 'psychology',
      label: 'Inteligência Artificial',
      icon: Icons.psychology_rounded,
      category: 'Inteligência & Robótica',
    ),
    DisciplineIconItem(
      key: 'smart_toy',
      label: 'Robótica / IA',
      icon: Icons.smart_toy_rounded,
      category: 'Inteligência & Robótica',
    ),
    DisciplineIconItem(
      key: 'precision_manufacturing',
      label: 'Automação Industrial',
      icon: Icons.precision_manufacturing_rounded,
      category: 'Inteligência & Robótica',
    ),
    DisciplineIconItem(
      key: 'tune',
      label: 'Sistemas de Controle',
      icon: Icons.tune_rounded,
      category: 'Inteligência & Robótica',
    ),
    DisciplineIconItem(
      key: 'bolt',
      label: 'Eletricidade & Eletrônica',
      icon: Icons.bolt_rounded,
      category: 'Inteligência & Robótica',
    ),
    DisciplineIconItem(
      key: 'settings_suggest',
      label: 'Eletrônica Digital',
      icon: Icons.settings_suggest_rounded,
      category: 'Inteligência & Robótica',
    ),

    // --- Matemática & Ciências Exatas ---
    DisciplineIconItem(
      key: 'functions',
      label: 'Cálculo Diferencial/Integral',
      icon: Icons.functions_rounded,
      category: 'Matemática & Ciências',
    ),
    DisciplineIconItem(
      key: 'calculate',
      label: 'Estatística / Numérico',
      icon: Icons.calculate_rounded,
      category: 'Matemática & Ciências',
    ),
    DisciplineIconItem(
      key: 'square_foot',
      label: 'Geometria Analítica',
      icon: Icons.square_foot_rounded,
      category: 'Matemática & Ciências',
    ),
    DisciplineIconItem(
      key: 'science',
      label: 'Física / Química',
      icon: Icons.science_rounded,
      category: 'Matemática & Ciências',
    ),
    DisciplineIconItem(
      key: 'biotech',
      label: 'Ciência dos Materiais',
      icon: Icons.biotech_rounded,
      category: 'Matemática & Ciências',
    ),
    DisciplineIconItem(
      key: 'waves',
      label: 'Fenômenos de Transporte',
      icon: Icons.waves_rounded,
      category: 'Matemática & Ciências',
    ),
    DisciplineIconItem(
      key: 'view_in_ar',
      label: 'Mecânica dos Sólidos',
      icon: Icons.view_in_ar_rounded,
      category: 'Matemática & Ciências',
    ),

    // --- Projetos, Extensão & Metodologia ---
    DisciplineIconItem(
      key: 'school',
      label: 'TCC / Graduação',
      icon: Icons.school_rounded,
      category: 'Acadêmico & Projetos',
    ),
    DisciplineIconItem(
      key: 'assignment',
      label: 'Requisitos / Tópicos',
      icon: Icons.assignment_rounded,
      category: 'Acadêmico & Projetos',
    ),
    DisciplineIconItem(
      key: 'menu_book',
      label: 'Metodologia & Teoria',
      icon: Icons.menu_book_rounded,
      category: 'Acadêmico & Projetos',
    ),
    DisciplineIconItem(
      key: 'work',
      label: 'Estágio Supervisionado',
      icon: Icons.work_outline_rounded,
      category: 'Acadêmico & Projetos',
    ),
    DisciplineIconItem(
      key: 'handshake',
      label: 'Atividades de Extensão',
      icon: Icons.handshake_rounded,
      category: 'Acadêmico & Projetos',
    ),
    DisciplineIconItem(
      key: 'lightbulb',
      label: 'Empreendedorismo',
      icon: Icons.lightbulb_outline_rounded,
      category: 'Acadêmico & Projetos',
    ),
    DisciplineIconItem(
      key: 'eco',
      label: 'Sustentabilidade',
      icon: Icons.eco_rounded,
      category: 'Acadêmico & Projetos',
    ),
    DisciplineIconItem(
      key: 'brush',
      label: 'Expressão Gráfica',
      icon: Icons.brush_rounded,
      category: 'Acadêmico & Projetos',
    ),

    // --- Idiomas & Geral ---
    DisciplineIconItem(
      key: 'translate',
      label: 'Idiomas / Línguas',
      icon: Icons.translate_rounded,
      category: 'Geral & Humanas',
    ),
    DisciplineIconItem(
      key: 'bookmark',
      label: 'Geral',
      icon: Icons.bookmark_border_rounded,
      category: 'Geral & Humanas',
    ),
    DisciplineIconItem(
      key: 'star',
      label: 'Destaque',
      icon: Icons.star_border_rounded,
      category: 'Geral & Humanas',
    ),
  ];

  static IconData getIcon(String key) {
    final item = allIcons.firstWhere(
      (icon) => icon.key == key,
      orElse: () => allIcons.first,
    );
    return item.icon;
  }

  static String getLabel(String key) {
    final item = allIcons.firstWhere(
      (icon) => icon.key == key,
      orElse: () => allIcons.first,
    );
    return item.label;
  }

  /// Suggests an icon key based on keywords inside course name.
  static String suggestIcon(String courseName) {
    final clean = _normalize(courseName);

    if (clean.isEmpty) return 'code';

    // AI & Machine Learning & Robótica
    if (clean.contains('inteligencia') ||
        clean.contains('ia') ||
        clean.contains('machine learning') ||
        clean.contains('neural')) {
      return 'psychology';
    }
    if (clean.contains('robotica')) {
      return 'smart_toy';
    }
    if (clean.contains('automacao') || clean.contains('controle')) {
      return 'precision_manufacturing';
    }

    // Banco de dados
    if (clean.contains('banco de dados') ||
        clean.contains('database') ||
        clean.contains('sql') ||
        clean.contains('dados')) {
      return 'storage';
    }

    // Redes & Nuvem
    if (clean.contains('nuvem') || clean.contains('cloud')) {
      return 'cloud';
    }
    if (clean.contains('rede') || clean.contains('telecom')) {
      return 'hub';
    }

    // Mobile
    if (clean.contains('mobile') ||
        clean.contains('celular') ||
        clean.contains('android') ||
        clean.contains('ios') ||
        clean.contains('flutter')) {
      return 'smartphone';
    }

    // Segurança
    if (clean.contains('seguranca') ||
        clean.contains('cripto') ||
        clean.contains('security')) {
      return 'lock';
    }

    // Estruturas & Algoritmos
    if (clean.contains('estrutura de dados') || clean.contains('algoritmo')) {
      return 'account_tree';
    }

    // Matemática, Cálculo, Estatística
    if (clean.contains('calculo') ||
        clean.contains('diferencial') ||
        clean.contains('integral')) {
      return 'functions';
    }
    if (clean.contains('estatistica') ||
        clean.contains('probabilidade') ||
        clean.contains('numerico') ||
        clean.contains('matematica')) {
      return 'calculate';
    }
    if (clean.contains('geometria') || clean.contains('grafica')) {
      return 'square_foot';
    }

    // Física, Química, Eletrônica
    if (clean.contains('eletronica') ||
        clean.contains('eletricidade') ||
        clean.contains('magnetismo') ||
        clean.contains('circuit')) {
      return 'bolt';
    }
    if (clean.contains('fisica') ||
        clean.contains('quimica') ||
        clean.contains('experimento')) {
      return 'science';
    }
    if (clean.contains('materiais')) {
      return 'biotech';
    }
    if (clean.contains('transporte') || clean.contains('fenomenos')) {
      return 'waves';
    }
    if (clean.contains('solidos') || clean.contains('mecanica')) {
      return 'view_in_ar';
    }

    // Hardware, Arquitetura, Embarcados, Sistemas Operacionais
    if (clean.contains('arquitetura de computadores') ||
        clean.contains('organizacao') ||
        clean.contains('embarcado') ||
        clean.contains('sistemas operacionais') ||
        clean.contains('hardware')) {
      return 'memory';
    }

    // Idiomas
    if (clean.contains('japones') ||
        clean.contains('ingles') ||
        clean.contains('idioma') ||
        clean.contains('lingua') ||
        clean.contains('espanhol')) {
      return 'translate';
    }

    // Acadêmico & Extensão
    if (clean.contains('tcc') ||
        clean.contains('conclusao de curso') ||
        clean.contains('topicos integradores')) {
      return 'school';
    }
    if (clean.contains('estagio')) {
      return 'work';
    }
    if (clean.contains('extensao')) {
      return 'handshake';
    }
    if (clean.contains('requisitos')) {
      return 'assignment';
    }
    if (clean.contains('metodologia') || clean.contains('teoria')) {
      return 'menu_book';
    }
    if (clean.contains('sustentavel') || clean.contains('direitos')) {
      return 'eco';
    }
    if (clean.contains('empreendedorismo')) {
      return 'lightbulb';
    }

    // Programação em geral
    if (clean.contains('web') ||
        clean.contains('front') ||
        clean.contains('back') ||
        clean.contains('framework')) {
      return 'developer_mode';
    }
    if (clean.contains('concorrente') || clean.contains('distribuida')) {
      return 'devices';
    }
    if (clean.contains('programacao') ||
        clean.contains('coding') ||
        clean.contains('codigo') ||
        clean.contains('software')) {
      return 'code';
    }

    return 'code';
  }

  static String _normalize(String text) {
    var str = text.toLowerCase();
    const withAccents = 'àáâãäåèéêëìíîïòóôõöùúûüçñ';
    const withoutAccents = 'aaaaaaeeeeiiiiooooouuuucn';
    for (int i = 0; i < withAccents.length; i++) {
      str = str.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return str;
  }
}
