import 'package:flutter/material.dart';
import '../models/absence_record.dart';
import '../models/discipline.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/discipline_card.dart';
import 'add_edit_discipline_screen.dart';
import 'discipline_detail_screen.dart';

class DisciplinesScreen extends StatelessWidget {
  final AppState appState;

  const DisciplinesScreen({super.key, required this.appState});

  void _openNew(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddEditDisciplineScreen(appState: appState),
    ));
  }

  Future<void> _quickAdd(BuildContext context, Discipline d) async {
    final messenger = ScaffoldMessenger.of(context);
    final now = DateTime.now();
    final already = d.absences.any(
      (a) => a.date.year == now.year && a.date.month == now.month && a.date.day == now.day,
    );
    messenger.hideCurrentSnackBar();
    if (already) {
      messenger.showSnackBar(SnackBar(
        content: Text('Já tem falta registrada hoje em ${d.name}.'),
      ));
      return;
    }

    final record = AbsenceRecord(id: now.millisecondsSinceEpoch.toString(), date: now);
    await appState.addAbsence(d.id, record);
    messenger.showSnackBar(SnackBar(
      content: Text('Falta de hoje registrada em ${d.name}.'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () => appState.deleteAbsence(d.id, record.id),
      ),
    ));
  }

  String _summary() {
    final n = appState.totalDisciplines;
    final atRisk = appState.disciplinesAtRisk;
    final count = '$n ${n == 1 ? 'disciplina' : 'disciplinas'}';
    if (atRisk == 0) return '$count, tudo em dia';
    return '$count, $atRisk perto do limite';
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disciplines = appState.disciplines;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 8, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Frequência',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -0.5,
                              color: p.ink,
                            ),
                          ),
                          if (disciplines.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              _summary(),
                              style: TextStyle(fontSize: 15, color: p.inkSoft),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: p.inkSoft,
                      ),
                      tooltip: isDark ? 'Usar tema claro' : 'Usar tema escuro',
                      onPressed: appState.toggleTheme,
                    ),
                  ],
                ),
              ),
            ),
            if (disciplines.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: p.rule),
                      const SizedBox(height: 28),
                      Text(
                        'Nenhuma disciplina adicionada',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: p.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adicione as matérias do semestre com quantos dias dá pra faltar em cada uma. '
                        'Depois é só registrar os dias que você faltar.',
                        style: TextStyle(fontSize: 15, height: 1.45, color: p.inkSoft),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar disciplina'),
                        onPressed: () => _openNew(context),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList.separated(
                itemCount: disciplines.length + 1,
                separatorBuilder: (_, _) =>
                    Divider(indent: 20, endIndent: 20, color: p.rule),
                itemBuilder: (context, index) {
                  if (index == 0) return const SizedBox.shrink();
                  final discipline = disciplines[index - 1];
                  return DisciplineCard(
                    discipline: discipline,
                    onQuickAdd: () => _quickAdd(context, discipline),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DisciplineDetailScreen(
                        disciplineId: discipline.id,
                        appState: appState,
                      ),
                    )),
                  );
                },
              ),
            if (disciplines.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
      floatingActionButton: disciplines.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _openNew(context),
              icon: const Icon(Icons.add),
              label: const Text(
                'Nova disciplina',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }
}
