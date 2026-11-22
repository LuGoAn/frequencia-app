import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/absence_record.dart';
import '../theme/app_colors.dart';

class RecordAbsenceSheet extends StatefulWidget {
  final AbsenceRecord? initialRecord;
  final List<DateTime> takenDates;
  final void Function(DateTime date) onSave;

  const RecordAbsenceSheet({
    super.key,
    this.initialRecord,
    this.takenDates = const [],
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    AbsenceRecord? initialRecord,
    List<DateTime> takenDates = const [],
    required void Function(DateTime date) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => RecordAbsenceSheet(
        initialRecord: initialRecord,
        takenDates: takenDates,
        onSave: onSave,
      ),
    );
  }

  @override
  State<RecordAbsenceSheet> createState() => _RecordAbsenceSheetState();
}

class _RecordAbsenceSheetState extends State<RecordAbsenceSheet> {
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialRecord?.date ?? DateTime.now();
  }

  bool get _alreadyTaken => widget.takenDates.any(
        (d) => d.year == _date.year && d.month == _date.month && d.day == _date.day,
      );

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
                border: Border.all(color: _alreadyTaken ? p.red : p.rule),
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
          if (_alreadyTaken) ...[
            const SizedBox(height: 8),
            Text(
              'Já tem uma falta registrada nesse dia.',
              style: TextStyle(fontSize: 14, color: p.red),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _alreadyTaken
                ? null
                : () {
                    widget.onSave(_date);
                    Navigator.of(context).pop();
                  },
            child: Text(isEditing ? 'Salvar' : 'Registrar falta'),
          ),
        ],
      ),
    );
  }
}
