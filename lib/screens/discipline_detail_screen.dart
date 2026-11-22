import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/absence_record.dart';
import '../models/discipline.dart';
import '../services/attendance_calculator.dart';
import '../services/icon_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/attendance_grid.dart';
import '../widgets/record_absence_sheet.dart';
import '../widgets/status_badge.dart';
import 'add_edit_discipline_screen.dart';

class DisciplineDetailScreen extends StatelessWidget {
  final String disciplineId;
  final AppState appState;

  const DisciplineDetailScreen({
    super.key,
    required this.disciplineId,
    required this.appState,
  });

  Future<void> _confirmDeleteDiscipline(BuildContext context, Discipline d) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir disciplina?'),
        content: Text('"${d.name}" e todas as faltas registradas nela vão ser apagadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Palette.of(ctx).red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.of(context).pop();
      await appState.deleteDiscipline(d.id);
    }
  }

  Future<void> _confirmDeleteAbsence(
      BuildContext context, AbsenceRecord record, Discipline d) async {
    final date = DateFormat("d 'de' MMMM", 'pt_BR').format(record.date);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover falta?'),
        content: Text('A falta de $date sai do histórico.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Palette.of(ctx).red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (ok == true) await appState.deleteAbsence(d.id, record.id);
  }

  void _editAbsence(BuildContext context, AbsenceRecord record, Discipline d) {
    RecordAbsenceSheet.show(
      context: context,
      initialRecord: record,
      takenDates: [for (final a in d.absences) if (a.id != record.id) a.date],
      onSave: (date) => appState.updateAbsence(d.id, record.copyWith(date: date)),
    );
  }

  String _remainingText(int left) {
    if (left > 0) return 'Dá pra faltar mais ${AttendanceCalculator.dias(left)}.';
    if (left == 0) return 'Você está no limite. Mais uma falta e reprova por frequência.';
    return 'Passou do limite em ${AttendanceCalculator.dias(-left)}.';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final d = appState.getDisciplineById(disciplineId);
        if (d == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Essa disciplina foi excluída.')),
          );
        }

        final p = Palette.of(context);
        final used = d.missedDays;
        final limit = d.absenceLimit;
        final status = AttendanceCalculator.getStatus(missed: used, limit: limit);
        final color = p.forStatus(status);
        final frequency = AttendanceCalculator.frequencyPercentage(
          missed: used,
          totalClasses: d.totalExpectedClasses,
        );
        final left = AttendanceCalculator.remaining(limit, used);

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Editar disciplina',
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AddEditDisciplineScreen(
                    appState: appState,
                    discipline: d,
                  ),
                )),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Excluir disciplina',
                onPressed: () => _confirmDeleteDiscipline(context, d),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            children: [
              Text(
                d.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  letterSpacing: -0.3,
                  color: p.ink,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(IconService.getIcon(d.iconKey), size: 18, color: p.inkSoft),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pode faltar até ${AttendanceCalculator.dias(limit)}',
                      style: TextStyle(fontSize: 14, color: p.inkSoft),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$used',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                      height: 0.9,
                      letterSpacing: -2,
                      color: color,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${used == 1 ? 'dia' : 'dias'} de falta\nde $limit',
                      style: TextStyle(fontSize: 15, height: 1.25, color: p.inkSoft),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: StatusBadge(status: status),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                _remainingText(left),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: left < 0 ? p.red : p.ink,
                ),
              ),
              const SizedBox(height: 24),
              AttendanceGrid(limit: limit, missed: used),
              const SizedBox(height: 12),
              Text(
                'Cada quadrado é um dia que dá pra faltar. Frequência estimada em ${frequency.toStringAsFixed(0)}%.',
                style: TextStyle(fontSize: 13, height: 1.4, color: p.inkFaint),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Registrar falta'),
                onPressed: () => RecordAbsenceSheet.show(
                  context: context,
                  takenDates: [for (final a in d.absences) a.date],
                  onSave: (date) => appState.addAbsence(
                    d.id,
                    AbsenceRecord(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: date,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Histórico',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: p.ink,
                    ),
                  ),
                  const Spacer(),
                  if (d.absences.isNotEmpty)
                    Text(
                      '${d.absences.length} ${d.absences.length == 1 ? 'registro' : 'registros'}',
                      style: TextStyle(fontSize: 13, color: p.inkFaint),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: p.rule),
              if (d.absences.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Nenhuma falta registrada ainda.',
                    style: TextStyle(fontSize: 15, color: p.inkSoft),
                  ),
                )
              else
                for (final record in d.absences) ...[
                  _AbsenceRow(
                    record: record,
                    onEdit: () => _editAbsence(context, record, d),
                    onDelete: () => _confirmDeleteAbsence(context, record, d),
                  ),
                  Divider(color: p.rule),
                ],
            ],
          ),
        );
      },
    );
  }
}

class _AbsenceRow extends StatelessWidget {
  final AbsenceRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AbsenceRow({
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final day = DateFormat("d 'de' MMMM", 'pt_BR').format(record.date);
    final weekday = DateFormat('EEEE', 'pt_BR').format(record.date);

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    weekday,
                    style: TextStyle(fontSize: 13, color: p.inkFaint),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: p.inkFaint),
              tooltip: 'Opções',
              onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Mudar data')),
                PopupMenuItem(value: 'delete', child: Text('Remover')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
