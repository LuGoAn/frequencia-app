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

  late String _selectedIconKey;
  late int _periodsPerClass;
  bool _manuallyPickedIcon = false;

  bool get isEditing => widget.discipline != null;

  @override
  void initState() {
    super.initState();
    final d = widget.discipline;
    _nameController = TextEditingController(text: d?.name ?? '');
    _limitController = TextEditingController(
      text: d != null
          ? (d.absenceLimit == d.absenceLimit.roundToDouble()
              ? d.absenceLimit.toInt().toString()
              : d.absenceLimit.toString())
          : '15',
    );
    _selectedIconKey = d?.iconKey ?? 'code';
    _periodsPerClass = d?.periodsPerClass ?? 2;
    if (d != null) {
      _manuallyPickedIcon = true;
    }

    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    // If the user hasn't explicitly chosen an icon, suggest one based on typing
    if (!_manuallyPickedIcon && !isEditing) {
      final text = _nameController.text.trim();
      if (text.isNotEmpty) {
        final suggested = IconService.suggestIcon(text);
        if (suggested != _selectedIconKey) {
          setState(() {
            _selectedIconKey = suggested;
          });
        }
      }
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
    final limit = double.tryParse(_limitController.text.replaceAll(',', '.')) ?? 15.0;

    if (isEditing) {
      final updated = widget.discipline!.copyWith(
        name: name,
        iconKey: _selectedIconKey,
        periodsPerClass: _periodsPerClass,
        absenceLimit: limit,
      );
      await widget.appState.updateDiscipline(updated);
    } else {
      final newDiscipline = Discipline(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        iconKey: _selectedIconKey,
        periodsPerClass: _periodsPerClass,
        absenceLimit: limit,
      );
      await widget.appState.addDiscipline(newDiscipline);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar disciplina' : 'Nova disciplina'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
            physics: const BouncingScrollPhysics(),
            children: [
              // Icon selector container
              Center(
                child: Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: _openIconPicker,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.primaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.primary.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          IconService.getIcon(_selectedIconKey),
                          size: 38,
                          color: isDark ? AppColors.primaryLight : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _openIconPicker,
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: Text(
                        'Trocar ícone (${IconService.getLabel(_selectedIconKey)})',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Discipline Name
              Text(
                'Nome da disciplina',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Ex: Banco de Dados, Programação...',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o nome da disciplina';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tempos por aula / encontro
              Text(
                'Quantidade de tempos por aula/encontro',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Quantas aulas/períodos acontecem no mesmo dia desta matéria',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [1, 2, 3].map((count) {
                  final isSelected = _periodsPerClass == count;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: count < 3 ? 10 : 0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => setState(() => _periodsPerClass = count),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.primaryLight.withOpacity(0.18)
                                    : AppColors.primaryContainer.withOpacity(0.5))
                                : (isDark
                                    ? AppColors.darkSurface
                                    : AppColors.lightSurface),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              width: isSelected ? 1.8 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                      : (isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                count == 1 ? 'tempo' : 'tempos',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Limite de Faltas
              Text(
                'Limite de faltas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Número máximo de faltas permitido na disciplina (ex: 15)',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _limitController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '15',
                  suffixText: 'faltas',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Informe o limite de faltas';
                  }
                  final numVal = double.tryParse(val.replaceAll(',', '.'));
                  if (numVal == null || numVal <= 0) {
                    return 'Informe um número válido maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),

              // Save button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(
                    isEditing ? 'Salvar alterações' : 'Adicionar disciplina',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
