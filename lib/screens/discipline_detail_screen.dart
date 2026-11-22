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
      periodsPerClass: d.periodsPerClass,
      initialRecord: record,
      onSave: (date, periods) => appState.updateAbsence(
        d.id,
        record.copyWith(date: date, missedPeriods: periods),
      ),
    );
  }

  String _remainingText(double remaining, int remainingPeriods) {
    final f = AttendanceCalculator.formatAbsences;
    if (remaining > 0) {
      final faltas = AttendanceCalculator.faltaWord(remaining);
      final tempos = remainingPeriods == 1 ? 'tempo' : 'tempos';
      return 'Ainda cabem ${f(remaining)} $faltas ($remainingPeriods $tempos).';
    }
    if (remaining == 0) {
      return 'Você está no limite. Mais uma falta e reprova por frequência.';
    }
    return 'Passou do limite em ${f(remaining.abs())} ${AttendanceCalculator.faltaWord(remaining.abs())}.';
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
        final used = d.equivalentAbsences;
        final limit = d.absenceLimit;
        final status = AttendanceCalculator.getStatus(
          equivalentAbsences: used,
          limit: limit,
        );
        final color = p.forStatus(status);
        final frequency = AttendanceCalculator.calculateFrequencyPercentage(
          equivalentAbsences: used,
          totalExpectedClasses: d.totalExpectedClasses,
        );
        final remaining = AttendanceCalculator.calculateRemainingAbsences(limit, used);
        final remainingPeriods = AttendanceCalculator.calculateRemainingPeriods(
          limit,
          d.periodsPerClass,
          d.totalMissedPeriods,
        );
        final f = AttendanceCalculator.formatAbsences;

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
                      '${d.periodsPerClass} ${d.periodsPerClass == 1 ? 'tempo' : 'tempos'} por aula, '
                      'limite de ${f(limit)} faltas',
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
                    f(used),
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
                      used == 1 ? 'falta\nde ${f(limit)}' : 'faltas\nde ${f(limit)}',
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
                _remainingText(remaining, remainingPeriods),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: remaining < 0 ? p.red : p.ink,
                ),
              ),
              const SizedBox(height: 24),
              AttendanceGrid(
                limit: limit,
                periodsPerClass: d.periodsPerClass,
                missedPeriods: d.totalMissedPeriods,
              ),
              const SizedBox(height: 12),
              Text(
                'Cada quadrado é um tempo de aula. Frequência estimada em ${frequency.toStringAsFixed(0)}%.',
                style: TextStyle(fontSize: 13, height: 1.4, color: p.inkFaint),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Registrar falta'),
                onPressed: () => RecordAbsenceSheet.show(
                  context: context,
                  periodsPerClass: d.periodsPerClass,
                  onSave: (date, periods) => appState.addAbsence(
                    d.id,
                    AbsenceRecord(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      date: date,
                      missedPeriods: periods,
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
                    periodsPerClass: d.periodsPerClass,
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
  final int periodsPerClass;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AbsenceRow({
    required this.record,
    required this.periodsPerClass,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final eq = AttendanceCalculator.calculateEquivalentAbsences(
      record.periodsCount,
      periodsPerClass,
    );
    final day = DateFormat('d MMM', 'pt_BR').format(record.date).replaceAll('.', '');
    final weekday = DateFormat('EEEE', 'pt_BR').format(record.date);

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 76,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.ink),
                  ),
                  Text(
                    weekday.split('-').first,
                    style: TextStyle(fontSize: 12, color: p.inkFaint),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AttendanceCalculator.formatPeriodsDescription(
                      record.missedPeriods,
                      periodsPerClass,
                    ),
                    style: TextStyle(fontSize: 15, color: p.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${AttendanceCalculator.formatAbsences(eq)} ${AttendanceCalculator.faltaWord(eq)}',
                    style: TextStyle(fontSize: 13, color: p.red),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: p.inkFaint),
              tooltip: 'Opções',
              onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(value: 'delete', child: Text('Remover')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
