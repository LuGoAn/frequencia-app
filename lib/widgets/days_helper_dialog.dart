import 'package:flutter/material.dart';
import '../services/attendance_calculator.dart';
import '../theme/app_colors.dart';

// Pra quem vê o limite no sistema em faltas por tempo de aula (ex: 0/15 com 3 tempos por dia).
class DaysHelperDialog extends StatefulWidget {
  const DaysHelperDialog({super.key});

  static Future<int?> show(BuildContext context) {
    return showDialog<int>(
      context: context,
      builder: (_) => const DaysHelperDialog(),
    );
  }

  @override
  State<DaysHelperDialog> createState() => _DaysHelperDialogState();
}

class _DaysHelperDialogState extends State<DaysHelperDialog> {
  final _limitController = TextEditingController();
  final _periodsController = TextEditingController();

  @override
  void dispose() {
    _limitController.dispose();
    _periodsController.dispose();
    super.dispose();
  }

  int? get _days {
    final limit = int.tryParse(_limitController.text.trim());
    final periods = int.tryParse(_periodsController.text.trim());
    if (limit == null || periods == null || limit <= 0 || periods <= 0) return null;
    return AttendanceCalculator.daysFromPeriods(limit, periods);
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final days = _days;

    return AlertDialog(
      title: const Text('Calcular os dias'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Se no sistema da faculdade cada tempo de aula conta uma falta, '
            'é só dividir o limite pelos tempos que a matéria tem num dia.',
            style: TextStyle(fontSize: 14, height: 1.4, color: p.inkSoft),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _limitController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Limite no sistema',
              hintText: '15',
              suffixText: 'faltas',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _periodsController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Tempos num dia de aula',
              hintText: '3',
              suffixText: 'tempos',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            days == null
                ? 'Preencha os dois campos.'
                : days == 0
                    ? 'Não dá nem um dia inteiro.'
                    : 'Dá pra faltar ${AttendanceCalculator.dias(days)}.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.ink),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: days != null && days > 0 ? () => Navigator.of(context).pop(days) : null,
          child: Text(days != null && days > 0 ? 'Usar ${AttendanceCalculator.dias(days)}' : 'Usar'),
        ),
      ],
    );
  }
}
