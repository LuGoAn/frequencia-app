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
      text: d != null
          ? (d.absenceLimit == d.absenceLimit.roundToDouble()
              ? d.absenceLimit.toInt().toString()
              : d.absenceLimit.toString())
          : '15',
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
    final limit = double.tryParse(_limitController.text.replaceAll(',', '.')) ?? 15.0;
    final periods = _periodsPerClass > 0 ? _periodsPerClass : 2;

    if (isEditing) {
      final updated = widget.discipline!.copyWith(
        name: name,
        iconKey: _selectedIconKey,
        periodsPerClass: periods,
        absenceLimit: limit,
      );
      await widget.appState.updateDiscipline(updated);
    } else {
      final newDiscipline = Discipline(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        iconKey: _selectedIconKey,
        periodsPerClass: periods,
        absenceLimit: limit,
      );
      await widget.appState.addDiscipline(newDiscipline);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildPeriodOption({
    required String label,
    required String subLabel,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    bool isCustom = false,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? AppColors.primaryLight.withOpacity(0.18)
                    : AppColors.primaryContainer.withOpacity(0.5))
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isCustom && label == '+' ? 22 : 19,
                  fontWeight: FontWeight.w800,
                  color: isSelected
                      ? (isDark ? AppColors.primaryLight : AppColors.primary)
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
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

              // 1, 2, 3 padrão + botão Personalizado
              Row(
                children: [
                  _buildPeriodOption(
                    label: '1',
                    subLabel: 'tempo',
                    isSelected: !_isCustomPeriods && _periodsPerClass == 1,
                    onTap: () {
                      setState(() {
                        _isCustomPeriods = false;
                        _periodsPerClass = 1;
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildPeriodOption(
                    label: '2',
                    subLabel: 'tempos',
                    isSelected: !_isCustomPeriods && _periodsPerClass == 2,
                    onTap: () {
                      setState(() {
                        _isCustomPeriods = false;
                        _periodsPerClass = 2;
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildPeriodOption(
                    label: '3',
                    subLabel: 'tempos',
                    isSelected: !_isCustomPeriods && _periodsPerClass == 3,
                    onTap: () {
                      setState(() {
                        _isCustomPeriods = false;
                        _periodsPerClass = 3;
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildPeriodOption(
                    label: _isCustomPeriods ? '$_periodsPerClass' : '+',
                    subLabel: _isCustomPeriods ? 'tempos' : 'Outro',
                    isSelected: _isCustomPeriods,
                    isCustom: true,
                    onTap: () {
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
                    },
                    isDark: isDark,
                  ),
                ],
              ),

              // Seletor numérico para valor personalizado
              if (_isCustomPeriods) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valor personalizado',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Defina o número exato de tempos (ex: 4, 6, 8)',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded, size: 18),
                              onPressed: _periodsPerClass > 1
                                  ? () {
                                      setState(() {
                                        _periodsPerClass--;
                                        _customPeriodsController.text = '$_periodsPerClass';
                                      });
                                    }
                                  : null,
                              visualDensity: VisualDensity.compact,
                            ),
                            SizedBox(
                              width: 38,
                              child: TextFormField(
                                controller: _customPeriodsController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                                onChanged: (val) {
                                  final n = int.tryParse(val);
                                  if (n != null && n > 0 && n <= 30) {
                                    setState(() {
                                      _periodsPerClass = n;
                                    });
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded, size: 18),
                              onPressed: _periodsPerClass < 30
                                  ? () {
                                      setState(() {
                                        _periodsPerClass++;
                                        _customPeriodsController.text = '$_periodsPerClass';
                                      });
                                    }
                                  : null,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
