import 'package:flutter/material.dart';
import '../models/discipline.dart';
import '../services/icon_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/icon_picker_sheet.dart';

class AddEditDisciplineScreen extends StatefulWidget {
  final AppState appState;
  final Discipline? discipline;

  const AddEditDisciplineScreen({
    super.key,
    required this.appState,
    this.discipline,
  });

  @override
  State<AddEditDisciplineScreen> createState() => _AddEditDisciplineScreenState();
}

class _AddEditDisciplineScreenState extends State<AddEditDisciplineScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _limitController;
  late TextEditingController _customPeriodsController;

  late String _selectedIconKey;
  late int _periodsPerClass;
  bool _isCustomPeriods = false;
  bool _manuallyPickedIcon = false;

  bool get isEditing => widget.discipline != null;

  @override
  void initState() {
    super.initState();
    final d = widget.discipline;
    _nameController = TextEditingController(text: d?.name ?? '');
    _limitController = TextEditingController(
      text: d != null ? '${d.absenceLimit}' : '15',
    );
    _selectedIconKey = d?.iconKey ?? 'code';
    _periodsPerClass = d?.periodsPerClass ?? 2;
    _isCustomPeriods = _periodsPerClass > 3;
    _customPeriodsController = TextEditingController(
      text: _isCustomPeriods ? '$_periodsPerClass' : '4',
    );
    if (d != null) {
      _manuallyPickedIcon = true;
    }

    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (_manuallyPickedIcon || isEditing) return;
    final text = _nameController.text.trim();
    if (text.isEmpty) return;
    final suggested = IconService.suggestIcon(text);
    if (suggested != _selectedIconKey) {
      setState(() => _selectedIconKey = suggested);
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _limitController.dispose();
    _customPeriodsController.dispose();
    super.dispose();
  }

  Future<void> _openIconPicker() async {
    final picked = await IconPickerSheet.show(context, _selectedIconKey);
    if (picked != null) {
      setState(() {
        _selectedIconKey = picked;
        _manuallyPickedIcon = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final limit = int.tryParse(_limitController.text.trim()) ?? 15;
    final periods = _periodsPerClass > 0 ? _periodsPerClass : 2;

    if (isEditing) {
      await widget.appState.updateDiscipline(widget.discipline!.copyWith(
        name: name,
        iconKey: _selectedIconKey,
        periodsPerClass: periods,
        absenceLimit: limit,
      ));
    } else {
      await widget.appState.addDiscipline(Discipline(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        iconKey: _selectedIconKey,
        periodsPerClass: periods,
        absenceLimit: limit,
      ));
    }

    if (mounted) Navigator.of(context).pop();
  }

  void _pickPreset(int n) {
    setState(() {
      _isCustomPeriods = false;
      _periodsPerClass = n;
    });
  }

  void _pickCustom() {
    setState(() {
      _isCustomPeriods = true;
      final parsed = int.tryParse(_customPeriodsController.text);
      if (parsed != null && parsed > 0) {
        _periodsPerClass = parsed;
      } else {
        _periodsPerClass = 4;
        _customPeriodsController.text = '4';
      }
    });
  }

  void _stepCustom(int delta) {
    final next = _periodsPerClass + delta;
    if (next < 1 || next > 30) return;
    setState(() {
      _periodsPerClass = next;
      _customPeriodsController.text = '$next';
    });
  }

  Widget _label(Palette p, String text, [String? hint]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.ink)),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(hint, style: TextStyle(fontSize: 13, color: p.inkFaint)),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar disciplina' : 'Nova disciplina'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _label(p, 'Nome'),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 17, color: p.ink),
                decoration: const InputDecoration(hintText: 'Ex: Banco de Dados'),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Escreva o nome da disciplina'
                    : null,
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _openIconPicker,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: p.cellEmpty,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(IconService.getIcon(_selectedIconKey), color: p.ink),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          IconService.getLabel(_selectedIconKey),
                          style: TextStyle(fontSize: 15, color: p.inkSoft),
                        ),
                      ),
                      Text(
                        'Trocar ícone',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.ink),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _label(p, 'Tempos por aula', 'Quantos tempos seguidos essa matéria tem no mesmo dia'),
              Row(
                children: [
                  for (final n in [1, 2, 3]) ...[
                    _PeriodChoice(
                      label: '$n',
                      selected: !_isCustomPeriods && _periodsPerClass == n,
                      onTap: () => _pickPreset(n),
                    ),
                    const SizedBox(width: 8),
                  ],
                  _PeriodChoice(
                    label: _isCustomPeriods ? '$_periodsPerClass' : 'Outro',
                    selected: _isCustomPeriods,
                    onTap: _pickCustom,
                  ),
                ],
              ),
              if (_isCustomPeriods) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text('Quantidade', style: TextStyle(fontSize: 15, color: p.inkSoft)),
                    ),
                    IconButton.outlined(
                      icon: const Icon(Icons.remove),
                      tooltip: 'Menos um tempo',
                      onPressed: _periodsPerClass > 1 ? () => _stepCustom(-1) : null,
                    ),
                    SizedBox(
                      width: 48,
                      child: TextFormField(
                        controller: _customPeriodsController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: p.ink),
                        decoration: const InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          final n = int.tryParse(val);
                          if (n != null && n > 0 && n <= 30) {
                            setState(() => _periodsPerClass = n);
                          }
                        },
                      ),
                    ),
                    IconButton.outlined(
                      icon: const Icon(Icons.add),
                      tooltip: 'Mais um tempo',
                      onPressed: _periodsPerClass < 30 ? () => _stepCustom(1) : null,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 28),
              _label(p, 'Limite de faltas', 'O número que aparece no sistema da faculdade. Cada tempo perdido conta uma falta'),
              TextFormField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 17, color: p.ink),
                decoration: const InputDecoration(hintText: '15', suffixText: 'faltas'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Coloque o limite de faltas';
                  }
                  final numVal = int.tryParse(val.trim());
                  if (numVal == null || numVal <= 0) {
                    return 'O limite precisa ser um número inteiro maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),
              FilledButton(
                onPressed: _save,
                child: Text(isEditing ? 'Salvar alterações' : 'Adicionar disciplina'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodChoice extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? p.ink : p.cellEmpty,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: label.length > 2 ? 15 : 19,
                fontWeight: FontWeight.w500,
                color: selected ? p.onInk : p.inkSoft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
