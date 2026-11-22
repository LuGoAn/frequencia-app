import 'package:flutter/material.dart';

class DisciplineIconItem {
  final String key;
  final String label;
  final IconData icon;
  final String category;

  const DisciplineIconItem(this.key, this.label, this.icon, this.category);
}

class IconService {
  static const _tec = 'Tecnologia';
  static const _eng = 'Engenharia';
  static const _exatas = 'Exatas';
  static const _saude = 'Saúde';
  static const _direito = 'Direito e Sociais';
  static const _negocios = 'Negócios';
  static const _artes = 'Artes e Comunicação';
  static const _humanas = 'Humanas e Letras';
  static const _geral = 'Geral';

  static const categories = [_tec, _eng, _exatas, _saude, _direito, _negocios, _artes, _humanas, _geral];

  static const List<DisciplineIconItem> allIcons = [
    DisciplineIconItem('code', 'Programação', Icons.code_rounded, _tec),
    DisciplineIconItem('terminal', 'Terminal / Sistemas', Icons.terminal_rounded, _tec),
    DisciplineIconItem('laptop', 'Computação', Icons.laptop_chromebook_rounded, _tec),
    DisciplineIconItem('developer_mode', 'Web', Icons.developer_mode_rounded, _tec),
    DisciplineIconItem('storage', 'Banco de Dados', Icons.storage_rounded, _tec),
    DisciplineIconItem('memory', 'Hardware / SO', Icons.memory_rounded, _tec),
    DisciplineIconItem('hub', 'Redes', Icons.hub_rounded, _tec),
    DisciplineIconItem('cloud', 'Nuvem', Icons.cloud_outlined, _tec),
    DisciplineIconItem('smartphone', 'Mobile', Icons.phone_android_rounded, _tec),
    DisciplineIconItem('lock', 'Segurança', Icons.lock_outline_rounded, _tec),
    DisciplineIconItem('devices', 'Sistemas Distribuídos', Icons.devices_rounded, _tec),
    DisciplineIconItem('account_tree', 'Estrutura de Dados', Icons.account_tree_rounded, _tec),
    DisciplineIconItem('psychology', 'Inteligência Artificial', Icons.psychology_rounded, _tec),

    DisciplineIconItem('engineering', 'Engenharia', Icons.engineering_rounded, _eng),
    DisciplineIconItem('construction', 'Construção Civil', Icons.construction_rounded, _eng),
    DisciplineIconItem('smart_toy', 'Robótica', Icons.smart_toy_rounded, _eng),
    DisciplineIconItem('precision_manufacturing', 'Automação', Icons.precision_manufacturing_rounded, _eng),
    DisciplineIconItem('tune', 'Controle', Icons.tune_rounded, _eng),
    DisciplineIconItem('bolt', 'Elétrica / Eletrônica', Icons.bolt_rounded, _eng),
    DisciplineIconItem('settings_suggest', 'Eletrônica Digital', Icons.settings_suggest_rounded, _eng),
    DisciplineIconItem('view_in_ar', 'Mecânica', Icons.view_in_ar_rounded, _eng),
    DisciplineIconItem('waves', 'Fenômenos de Transporte', Icons.waves_rounded, _eng),
    DisciplineIconItem('water_drop', 'Hidráulica', Icons.water_drop_outlined, _eng),

    DisciplineIconItem('functions', 'Cálculo', Icons.functions_rounded, _exatas),
    DisciplineIconItem('calculate', 'Matemática / Estatística', Icons.calculate_rounded, _exatas),
    DisciplineIconItem('square_foot', 'Geometria', Icons.square_foot_rounded, _exatas),
    DisciplineIconItem('science', 'Física / Química', Icons.science_rounded, _exatas),
    DisciplineIconItem('biotech', 'Biologia / Laboratório', Icons.biotech_rounded, _exatas),
    DisciplineIconItem('terrain', 'Geologia', Icons.terrain_rounded, _exatas),
    DisciplineIconItem('agriculture', 'Agronomia', Icons.agriculture_rounded, _exatas),
    DisciplineIconItem('eco', 'Meio Ambiente', Icons.eco_rounded, _exatas),

    DisciplineIconItem('medical_services', 'Medicina / Clínica', Icons.medical_services_rounded, _saude),
    DisciplineIconItem('monitor_heart', 'Fisiologia / Cardio', Icons.monitor_heart_rounded, _saude),
    DisciplineIconItem('accessibility_new', 'Anatomia', Icons.accessibility_new_rounded, _saude),
    DisciplineIconItem('local_hospital', 'Saúde Coletiva', Icons.local_hospital_rounded, _saude),
    DisciplineIconItem('healing', 'Enfermagem', Icons.healing_rounded, _saude),
    DisciplineIconItem('medication', 'Farmacologia', Icons.medication_rounded, _saude),
    DisciplineIconItem('vaccines', 'Imunologia', Icons.vaccines_rounded, _saude),
    DisciplineIconItem('coronavirus', 'Microbiologia', Icons.coronavirus_rounded, _saude),
    DisciplineIconItem('bloodtype', 'Hematologia', Icons.bloodtype_rounded, _saude),
    DisciplineIconItem('psychology_alt', 'Psicologia', Icons.psychology_alt_rounded, _saude),
    DisciplineIconItem('restaurant', 'Nutrição', Icons.restaurant_rounded, _saude),
    DisciplineIconItem('fitness_center', 'Educação Física', Icons.fitness_center_rounded, _saude),
    DisciplineIconItem('pets', 'Veterinária', Icons.pets_rounded, _saude),

    DisciplineIconItem('gavel', 'Direito', Icons.gavel_rounded, _direito),
    DisciplineIconItem('balance', 'Constitucional / Ética', Icons.balance_rounded, _direito),
    DisciplineIconItem('policy', 'Penal / Processo', Icons.policy_rounded, _direito),
    DisciplineIconItem('account_balance', 'Administração Pública', Icons.account_balance_rounded, _direito),
    DisciplineIconItem('groups', 'Sociologia', Icons.groups_rounded, _direito),
    DisciplineIconItem('public', 'Geografia / Internacional', Icons.public_rounded, _direito),

    DisciplineIconItem('business_center', 'Administração', Icons.business_center_rounded, _negocios),
    DisciplineIconItem('trending_up', 'Economia / Finanças', Icons.trending_up_rounded, _negocios),
    DisciplineIconItem('receipt_long', 'Contabilidade', Icons.receipt_long_rounded, _negocios),
    DisciplineIconItem('campaign', 'Marketing', Icons.campaign_rounded, _negocios),
    DisciplineIconItem('inventory_2', 'Logística', Icons.inventory_2_rounded, _negocios),
    DisciplineIconItem('lightbulb', 'Empreendedorismo', Icons.lightbulb_outline_rounded, _negocios),
    DisciplineIconItem('work', 'Estágio', Icons.work_outline_rounded, _negocios),

    DisciplineIconItem('architecture', 'Arquitetura', Icons.architecture_rounded, _artes),
    DisciplineIconItem('design_services', 'Design', Icons.design_services_rounded, _artes),
    DisciplineIconItem('brush', 'Desenho / Expressão Gráfica', Icons.brush_rounded, _artes),
    DisciplineIconItem('palette', 'Artes', Icons.palette_rounded, _artes),
    DisciplineIconItem('music_note', 'Música', Icons.music_note_rounded, _artes),
    DisciplineIconItem('photo_camera', 'Fotografia', Icons.photo_camera_rounded, _artes),
    DisciplineIconItem('movie', 'Cinema / Audiovisual', Icons.movie_rounded, _artes),
    DisciplineIconItem('newspaper', 'Jornalismo', Icons.newspaper_rounded, _artes),
    DisciplineIconItem('record_voice_over', 'Comunicação / Oratória', Icons.record_voice_over_rounded, _artes),

    DisciplineIconItem('history_edu', 'História', Icons.history_edu_rounded, _humanas),
    DisciplineIconItem('auto_stories', 'Literatura', Icons.auto_stories_rounded, _humanas),
    DisciplineIconItem('translate', 'Idiomas', Icons.translate_rounded, _humanas),
    DisciplineIconItem('forum', 'Filosofia', Icons.forum_rounded, _humanas),
    DisciplineIconItem('child_care', 'Pedagogia', Icons.child_care_rounded, _humanas),
    DisciplineIconItem('menu_book', 'Metodologia / Teoria', Icons.menu_book_rounded, _humanas),

    DisciplineIconItem('bookmark', 'Geral', Icons.bookmark_border_rounded, _geral),
    DisciplineIconItem('school', 'TCC', Icons.school_rounded, _geral),
    DisciplineIconItem('assignment', 'Projeto / Tópicos', Icons.assignment_rounded, _geral),
    DisciplineIconItem('handshake', 'Extensão', Icons.handshake_rounded, _geral),
    DisciplineIconItem('star', 'Destaque', Icons.star_border_rounded, _geral),
  ];

  // Em ordem: o primeiro que bater ganha, então o mais específico vem antes.
  // Cada termo precisa começar no início de uma palavra ("ia" não pega "anatomia").
  static const List<(String, List<String>)> _rules = [
    ('account_tree', ['estrutura de dados', 'estruturas de dados', 'algoritmo', 'grafos']),
    ('storage', ['banco de dados', 'bancos de dados', 'database', 'sql', 'mineracao de dados']),
    ('psychology_alt', ['psicolog', 'psicopatolog', 'neuropsic']),
    ('psychology', ['inteligencia artificial', 'ia', 'machine learning', 'aprendizado de maquina', 'redes neurais', 'neural']),
    ('smart_toy', ['robotica']),
    ('precision_manufacturing', ['automacao', 'manufatura']),
    ('construction', ['construcao', 'concreto', 'estruturas', 'resistencia dos materiais', 'topografia', 'obras', 'engenharia civil']),
    ('water_drop', ['hidraulica', 'hidrologia', 'saneamento']),
    ('architecture', ['arquitetura e urbanismo', 'urbanismo', 'projeto arquitetonico', 'paisagismo']),
    ('memory', ['arquitetura de computadores', 'organizacao de computadores', 'sistemas operacionais', 'embarcado', 'hardware', 'microcontrolador']),
    ('cloud', ['nuvem', 'cloud']),
    ('hub', ['redes de computadores', 'rede', 'redes', 'telecom']),
    ('smartphone', ['mobile', 'android', 'ios', 'flutter', 'dispositivos moveis']),
    ('lock', ['seguranca da informacao', 'ciberseguranca', 'cripto', 'security']),
    ('devices', ['concorrente', 'distribuid', 'paralel']),
    ('developer_mode', ['web', 'front', 'back', 'framework']),
    ('code', ['programacao', 'linguagem de programacao', 'linguagens de programacao', 'codigo', 'software', 'compilador']),
    ('laptop', ['computacao', 'informatica']),

    ('functions', ['calculo', 'diferencial', 'integral', 'equacoes']),
    ('calculate', ['estatistica', 'probabilidade', 'numerico', 'matematica', 'algebra', 'bioestatistica']),
    ('square_foot', ['geometria']),
    ('bolt', ['eletric', 'eletronica', 'eletromagnet', 'magnetismo', 'circuito', 'potencia']),
    ('settings_suggest', ['sistemas digitais', 'logica digital']),
    ('tune', ['controle', 'sinais']),
    ('waves', ['fenomenos de transporte', 'termodinamica', 'fluidos', 'calor']),
    ('view_in_ar', ['mecanica', 'solidos', 'dinamica', 'estatica', 'maquinas']),
    ('engineering', ['engenharia', 'materiais']),

    ('bloodtype', ['hematolog']),
    ('vaccines', ['imunolog', 'vacina']),
    ('coronavirus', ['microbiolog', 'parasitolog', 'infectolog', 'virolog']),
    ('medication', ['farmaco', 'farmacia', 'farmaceut']),
    ('monitor_heart', ['fisiolog', 'cardio', 'semiolog']),
    ('accessibility_new', ['anatomia', 'cinesiolog', 'fisioterapia']),
    ('healing', ['enfermagem', 'cuidado', 'primeiros socorros']),
    ('local_hospital', ['saude', 'epidemiolog', 'sus']),
    ('restaurant', ['nutricao', 'alimento', 'gastronomia', 'dietetica']),
    ('fitness_center', ['educacao fisica', 'esporte', 'treinamento', 'atividade fisica']),
    ('pets', ['veterinari', 'zootecnia', 'animal']),
    ('medical_services', ['medicina', 'clinica', 'cirurgia', 'pediatria', 'ginecolog', 'patolog', 'odontolog', 'histolog', 'embriolog']),
    ('biotech', ['biologia', 'bioquimica', 'genetica', 'citolog', 'celular', 'laboratorio']),
    ('science', ['fisica', 'quimica', 'experiment']),
    ('terrain', ['geolog', 'solos', 'mineral']),
    ('agriculture', ['agronomia', 'agricola', 'agro', 'cultivo']),
    ('eco', ['ambiental', 'ecolog', 'sustentab', 'meio ambiente']),

    ('policy', ['penal', 'processo penal', 'processo civil', 'processual', 'criminal', 'criminolog']),
    ('balance', ['constitucional', 'etica', 'direitos humanos', 'filosofia do direito']),
    ('gavel', ['direito', 'juridic', 'civil', 'trabalhista', 'tributari', 'empresarial', 'legislacao']),
    ('account_balance', ['administracao publica', 'gestao publica', 'politicas publicas', 'ciencia politica', 'politica']),
    ('groups', ['sociolog', 'antropolog', 'sociedade', 'servico social']),
    ('public', ['geografia', 'relacoes internacionais', 'geopolitica', 'cartografia']),

    ('receipt_long', ['contabil', 'auditoria', 'custos']),
    ('trending_up', ['economia', 'financ', 'mercado', 'investimento', 'macroeconomia', 'microeconomia']),
    ('campaign', ['marketing', 'publicidade', 'propaganda']),
    ('inventory_2', ['logistica', 'cadeia de suprimentos', 'estoque']),
    ('lightbulb', ['empreendedorismo', 'inovacao']),
    ('business_center', ['administracao', 'gestao', 'negocios', 'recursos humanos', 'rh']),
    ('work', ['estagio']),

    ('architecture', ['arquitetura']),
    ('design_services', ['design']),
    ('brush', ['desenho', 'expressao grafica', 'ilustracao']),
    ('palette', ['arte', 'artes', 'pintura', 'estetica']),
    ('music_note', ['musica', 'harmonia', 'canto', 'instrumento']),
    ('photo_camera', ['fotografia']),
    ('movie', ['cinema', 'audiovisual', 'roteiro', 'video']),
    ('newspaper', ['jornalismo', 'redacao jornalistica', 'reportagem']),
    ('record_voice_over', ['comunicacao', 'oratoria', 'retorica']),

    ('history_edu', ['historia']),
    ('auto_stories', ['literatura', 'leitura', 'producao textual', 'redacao']),
    ('translate', ['ingles', 'espanhol', 'japones', 'frances', 'alemao', 'libras', 'idioma', 'lingua']),
    ('forum', ['filosofia']),
    ('child_care', ['pedagogia', 'didatica', 'educacao', 'ensino', 'alfabetizacao']),

    ('school', ['tcc', 'trabalho de conclusao', 'conclusao de curso', 'monografia']),
    ('handshake', ['extensao']),
    ('assignment', ['requisitos', 'topicos', 'projeto integrador', 'seminario']),
    ('menu_book', ['metodologia', 'teoria', 'pesquisa']),
  ];

  static DisciplineIconItem _find(String key) => allIcons.firstWhere(
        (icon) => icon.key == key,
        orElse: () => allIcons.firstWhere((i) => i.key == 'bookmark'),
      );

  static IconData getIcon(String key) => _find(key).icon;

  static String getLabel(String key) => _find(key).label;

  static String suggestIcon(String courseName) {
    final clean = _normalize(courseName);
    if (clean.isEmpty) return 'bookmark';

    for (final (key, terms) in _rules) {
      for (final term in terms) {
        final t = _normalize(term);
        // termo curto tem que ser a palavra inteira, senão "ia" bate em "anatomia ii"
        final pattern = t.length <= 3 ? '\\b${RegExp.escape(t)}\\b' : '\\b${RegExp.escape(t)}';
        if (RegExp(pattern).hasMatch(clean)) return key;
      }
    }
    return 'bookmark';
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
