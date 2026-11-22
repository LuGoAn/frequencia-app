import 'package:flutter/material.dart';
import '../models/discipline.dart';
import '../services/icon_service.dart';
import '../widgets/days_helper_dialog.dart';
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

  late String _selectedIconKey;
  bool _manuallyPickedIcon = false;

  bool get isEditing => widget.discipline != null;

  @override
  void initState() {
    super.initState();
    final d = widget.discipline;
    _nameController = TextEditingController(text: d?.name ?? '');
    _limitController = TextEditingController(
      text: d != null ? '${d.absenceLimit}' : '',
    );
    _selectedIconKey = d?.iconKey ?? 'bookmark';
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
    final limit = int.parse(_limitController.text.trim());

    if (isEditing) {
      await widget.appState.updateDiscipline(widget.discipline!.copyWith(
        name: name,
        iconKey: _selectedIconKey,
        absenceLimit: limit,
      ));
    } else {
      await widget.appState.addDiscipline(Discipline(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        iconKey: _selectedIconKey,
        absenceLimit: limit,
      ));
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _openDaysHelper() async {
    final days = await DaysHelperDialog.show(context);
    if (days != null) setState(() => _limitController.text = '$days');
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
              _label(p, 'Dias que pode faltar', 'Quantos dias de aula dá pra faltar no semestre sem reprovar'),
              TextFormField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 17, color: p.ink),
                decoration: const InputDecoration(hintText: '5', suffixText: 'dias'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Coloque quantos dias pode faltar';
                  }
                  final numVal = int.tryParse(val.trim());
                  if (numVal == null || numVal <= 0) {
                    return 'Precisa ser um número inteiro maior que zero';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _openDaysHelper,
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                  child: const Text('Não sabe quantos dias?'),
                ),
              ),
              const SizedBox(height: 24),
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
