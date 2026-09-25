import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/absence_record.dart';
import '../models/discipline.dart';
import '../services/attendance_calculator.dart';
import '../services/icon_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
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

  void _showDeleteDisciplineDialog(BuildContext context, Discipline discipline) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir disciplina?'),
        content: Text(
          'Deseja realmente remover "${discipline.name}" e todo seu histórico de faltas? Esta ação não pode ser desfeita.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // pop dialog
              Navigator.of(context).pop(); // pop details screen
              await appState.deleteDiscipline(discipline.id);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(
                color: AppColors.alertRose,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAbsenceDialog(BuildContext context, AbsenceRecord record, Discipline discipline) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir falta?'),
        content: const Text(
          'Deseja remover este registro de falta do histórico?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await appState.deleteAbsence(discipline.id, record.id);
            },
            child: const Text(
              'Remover',
              style: TextStyle(
                color: AppColors.alertRose,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen to changes for this discipline from AppState
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final discipline = appState.getDisciplineById(disciplineId);

        if (discipline == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalhes')),
            body: const Center(child: Text('Disciplina não encontrada')),
          );
        }

        final equivalent = discipline.equivalentAbsences;
        final limit = discipline.absenceLimit;
        final totalMissedPeriods = discipline.totalMissedPeriods;
        final status = AttendanceCalculator.getStatus(
          equivalentAbsences: equivalent,
          limit: limit,
        );
        final frequency = AttendanceCalculator.calculateFrequencyPercentage(
          equivalentAbsences: equivalent,
          totalExpectedClasses: discipline.totalExpectedClasses,
        );
        final progress = limit > 0 ? (equivalent / limit).clamp(0.0, 1.0) : 0.0;
        final remaining = AttendanceCalculator.calculateRemainingAbsences(limit, equivalent);
        final remainingPeriods = AttendanceCalculator.calculateRemainingPeriods(
          limit,
          discipline.periodsPerClass,
          totalMissedPeriods,
        );

        Color indicatorColor;
        switch (status) {
          case AttendanceHealthStatus.safe:
            indicatorColor = isDark ? AppColors.darkSafeGreen : AppColors.safeGreen;
            break;
          case AttendanceHealthStatus.warning:
            indicatorColor = isDark ? AppColors.darkWarningAmber : AppColors.warningAmber;
            break;
          case AttendanceHealthStatus.reached:
          case AttendanceHealthStatus.exceeded:
            indicatorColor = isDark ? AppColors.darkAlertRose : AppColors.alertRose;
            break;
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 22),
                tooltip: 'Editar disciplina',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddEditDisciplineScreen(
                        appState: appState,
                        discipline: discipline,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 22),
                tooltip: 'Excluir disciplina',
                onPressed: () => _showDeleteDisciplineDialog(context, discipline),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 40),
            physics: const BouncingScrollPhysics(),
            children: [
              // Hero Summary Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon + Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.primaryContainer.withOpacity(0.4),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.primary.withOpacity(0.15),
                            ),
                          ),
                          child: Icon(
                            IconService.getIcon(discipline.iconKey),
                            color: isDark ? AppColors.primaryLight : AppColors.primary,
                            size: 26,
                          ),
                        ),
                        StatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Course Name
                    Text(
                      discipline.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${discipline.periodsPerClass} ${discipline.periodsPerClass == 1 ? 'tempo por aula' : 'tempos por aula'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Metrics Grid (Frequência & Faltas)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Frequência',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${frequency.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                  color: indicatorColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Faltas acumuladas',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AttendanceCalculator.formatAbsences(equivalent),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / ${AttendanceCalculator.formatAbsences(limit)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Visual Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceElevated
                            : AppColors.lightBorder.withOpacity(0.7),
                        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Contextual status message
                    Text(
                      remaining > 0
                          ? 'Você ainda pode faltar ${AttendanceCalculator.formatAbsences(remaining)} faltas ($remainingPeriods tempos).'
                          : remaining == 0
                              ? 'Você atingiu o limite de faltas permitido. Qualquer nova falta resultará em reprovação por frequência.'
                              : 'Atenção: você ultrapassou o limite em ${AttendanceCalculator.formatAbsences(remaining.abs())} faltas.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: remaining < 0
                            ? (isDark ? AppColors.darkAlertRose : AppColors.alertRose)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Prominent Action Button: + Registrar Falta
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    RecordAbsenceSheet.show(
                      context: context,
                      periodsPerClass: discipline.periodsPerClass,
                      onSave: (date, periods) {
                        final record = AbsenceRecord(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          date: date,
                          missedPeriods: periods,
                        );
                        appState.addAbsence(discipline.id, record);
                      },
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
                  label: const Text(
                    'Registrar falta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // History Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Histórico de faltas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  if (discipline.absences.isNotEmpty)
                    Text(
                      '${discipline.absences.length} ${discipline.absences.length == 1 ? 'registro' : 'registros'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Empty or List of History Records
              if (discipline.absences.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 40,
                        color: isDark ? AppColors.darkSafeGreen : AppColors.safeGreen,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Frequência perfeita!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nenhuma falta registrada nesta disciplina até o momento.',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...discipline.absences.map((record) {
                  final dayFormat = DateFormat("d 'de' MMMM", 'pt_BR');
                  final formattedDate = dayFormat.format(record.date);
                  final periodsDesc = AttendanceCalculator.formatPeriodsDescription(
                    record.missedPeriods,
                    discipline.periodsPerClass,
                  );
                  final eqFaltas = AttendanceCalculator.calculateEquivalentAbsences(
                    record.periodsCount,
                    discipline.periodsPerClass,
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Calendar date badge
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.lightBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                record.date.day.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                DateFormat('MMM', 'pt_BR')
                                    .format(record.date)
                                    .toUpperCase()
                                    .replaceAll('.', ''),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.primaryLight
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                periodsDesc,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${AttendanceCalculator.formatAbsences(eqFaltas)} ${eqFaltas == 1 ? 'falta equivalente' : 'faltas equivalentes'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Action Buttons: Edit and Delete
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 19),
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          tooltip: 'Editar registro',
                          onPressed: () {
                            RecordAbsenceSheet.show(
                              context: context,
                              periodsPerClass: discipline.periodsPerClass,
                              initialRecord: record,
                              onSave: (date, periods) {
                                final updated = record.copyWith(
                                  date: date,
                                  missedPeriods: periods,
                                );
                                appState.updateAbsence(discipline.id, updated);
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 19),
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                          tooltip: 'Remover falta',
                          onPressed: () => _showDeleteAbsenceDialog(context, record, discipline),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
