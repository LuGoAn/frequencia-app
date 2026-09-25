import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/absence_record.dart';
import '../services/attendance_calculator.dart';
import '../theme/app_colors.dart';

class RecordAbsenceSheet extends StatefulWidget {
  final int periodsPerClass;
  final AbsenceRecord? initialRecord;
  final Function(DateTime date, List<int> missedPeriods) onSave;

  const RecordAbsenceSheet({
    super.key,
    required this.periodsPerClass,
    this.initialRecord,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required int periodsPerClass,
    AbsenceRecord? initialRecord,
    required Function(DateTime date, List<int> missedPeriods) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RecordAbsenceSheet(
        periodsPerClass: periodsPerClass,
        initialRecord: initialRecord,
        onSave: onSave,
      ),
    );
  }

  @override
  State<RecordAbsenceSheet> createState() => _RecordAbsenceSheetState();
}

class _RecordAbsenceSheetState extends State<RecordAbsenceSheet> {
  late DateTime _selectedDate;
  final Set<int> _selectedPeriods = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialRecord != null) {
      _selectedDate = widget.initialRecord!.date;
      _selectedPeriods.addAll(widget.initialRecord!.missedPeriods);
    } else {
      _selectedDate = DateTime.now();
      // Default: select all periods (standard full absence)
      for (int i = 1; i <= widget.periodsPerClass; i++) {
        _selectedPeriods.add(i);
      }
    }
  }

  void _togglePeriod(int period) {
    setState(() {
      if (_selectedPeriods.contains(period)) {
        // Only remove if not the only one, or allow empty with disabled button
        _selectedPeriods.remove(period);
      } else {
        _selectedPeriods.add(period);
      }
    });
  }

  void _selectAll() {
    setState(() {
      for (int i = 1; i <= widget.periodsPerClass; i++) {
        _selectedPeriods.add(i);
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.initialRecord != null;

    final dateFormat = DateFormat("d 'de' MMMM, yyyy", 'pt_BR');
    final formattedDate = dateFormat.format(_selectedDate);

    // Calculate equivalent absences for the current selection
    final equivalent = AttendanceCalculator.calculateEquivalentAbsences(
      _selectedPeriods.length,
      widget.periodsPerClass,
    );

    final canSave = _selectedPeriods.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Editar registro de falta' : 'Registrar falta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 22),
                  onPressed: () => Navigator.of(context).pop(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date Selection Tile
            Text(
              'Data da aula',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Alterar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Periods Selection section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quais tempos você perdeu?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                if (widget.periodsPerClass > 1 &&
                    _selectedPeriods.length < widget.periodsPerClass)
                  GestureDetector(
                    onTap: _selectAll,
                    child: Text(
                      'Selecionar todos',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Period Selection Cards / Buttons
            Row(
              children: List.generate(widget.periodsPerClass, (index) {
                final period = index + 1;
                final isSelected = _selectedPeriods.contains(period);

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < widget.periodsPerClass - 1 ? 10 : 0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _togglePeriod(period),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.primaryLight.withOpacity(0.18)
                                  : AppColors.primaryContainer.withOpacity(0.5))
                              : (isDark
                                  ? AppColors.darkSurfaceElevated
                                  : AppColors.lightBackground),
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
                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 20,
                              color: isSelected
                                  ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                  : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$periodº tempo',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Real-time calculation helper card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedPeriods.isEmpty
                          ? 'Selecione pelo menos um tempo perdido.'
                          : '${_selectedPeriods.length} ${_selectedPeriods.length == 1 ? 'tempo selecionado' : 'tempos selecionados'} = ${AttendanceCalculator.formatAbsences(equivalent)} faltas equivalentes.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: canSave
                    ? () {
                        widget.onSave(
                          _selectedDate,
                          _selectedPeriods.toList()..sort(),
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text(
                  isEditing ? 'Atualizar falta' : 'Confirmar registro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
