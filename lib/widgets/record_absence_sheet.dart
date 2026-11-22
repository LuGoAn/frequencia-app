import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/absence_record.dart';
import '../services/attendance_calculator.dart';
import '../theme/app_colors.dart';

class RecordAbsenceSheet extends StatefulWidget {
  final int periodsPerClass;
  final AbsenceRecord? initialRecord;
  final void Function(DateTime date, List<int> missedPeriods) onSave;

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
    required void Function(DateTime date, List<int> missedPeriods) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => RecordAbsenceSheet(
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
  late DateTime _date;
  final Set<int> _selected = {};

  int get _n => widget.periodsPerClass;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecord;
    if (r != null) {
      _date = r.date;
      _selected.addAll(r.missedPeriods);
    } else {
      _date = DateTime.now();
      // na maioria das vezes falta a aula inteira
      _selected.addAll(List.generate(_n, (i) => i + 1));
    }
  }

  void _toggle(int period) {
    setState(() {
      if (!_selected.remove(period)) _selected.add(period);
    });
  }

  void _toggleAll() {
    setState(() {
      if (_selected.length == _n) {
        _selected.clear();
      } else {
        _selected.addAll(List.generate(_n, (i) => i + 1));
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final isEditing = widget.initialRecord != null;
    final date = DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(_date);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Editar falta' : 'Registrar falta',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: p.ink),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: p.rule),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_outlined, size: 20, color: p.inkSoft),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      date[0].toUpperCase() + date.substring(1),
                      style: TextStyle(fontSize: 16, color: p.ink),
                    ),
                  ),
                  Text(
                    'Mudar data',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.ink),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quais tempos você perdeu?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.ink),
                ),
              ),
              if (_n > 1)
                TextButton(
                  onPressed: _toggleAll,
                  child: Text(_selected.length == _n ? 'Limpar' : 'Aula inteira'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 1; i <= _n; i++)
                _PeriodCell(
                  period: i,
                  selected: _selected.contains(i),
                  onTap: () => _toggle(i),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _selected.isEmpty
                ? 'Marque pelo menos um tempo.'
                : 'Conta ${AttendanceCalculator.faltas(_selected.length)} nesse dia.',
            style: TextStyle(fontSize: 14, color: p.inkSoft),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _selected.isEmpty
                ? null
                : () {
                    widget.onSave(_date, _selected.toList()..sort());
                    Navigator.of(context).pop();
                  },
            child: Text(isEditing ? 'Salvar' : 'Registrar falta'),
          ),
        ],
      ),
    );
  }
}

class _PeriodCell extends StatelessWidget {
  final int period;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodCell({
    required this.period,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: '$periodº tempo',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? p.red : p.cellEmpty,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$periodº',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selected ? p.onRed : p.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}
