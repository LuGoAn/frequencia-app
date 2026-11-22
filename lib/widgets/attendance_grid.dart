import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Um quadrado por tempo que ainda dá pra faltar, agrupados por aula.
// Tempos além do limite aparecem depois de uma barra vermelha.
class AttendanceGrid extends StatelessWidget {
  final double limit;
  final int periodsPerClass;
  final int missedPeriods;

  const AttendanceGrid({
    super.key,
    required this.limit,
    required this.periodsPerClass,
    required this.missedPeriods,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final allowed = (limit * periodsPerClass).round();
    final total = max(allowed, missedPeriods);
    final perGroup = max(1, periodsPerClass);
    final groupCount = (total / perGroup).ceil();

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      // quadrado grande quando cabe, e linhas com a mesma quantidade de aulas
      double groupWidth(double c) => perGroup * c + (perGroup - 1) * _cellGap;
      final maxPerRow = max(1, ((w + _groupGap) / (groupWidth(16) + _groupGap)).floor());
      final rows = (groupCount / maxPerRow).ceil();
      final perRow = max(1, (groupCount / max(1, rows)).ceil());
      final fit = (w - (perRow - 1) * _groupGap - perRow * (perGroup - 1) * _cellGap) /
          (perRow * perGroup);
      final cellSize = (fit - 0.1).clamp(10.0, 30.0);
      return _build(p, allowed, total, perGroup, cellSize);
    });
  }

  static const _cellGap = 3.0;
  static const _groupGap = 9.0;

  Widget _build(Palette p, int allowed, int total, int perGroup, double cellSize) {
    final groups = <Widget>[];
    for (var start = 0; start < total; start += perGroup) {
      final end = min(start + perGroup, total);
      if (start == allowed && missedPeriods > allowed) {
        groups.add(Container(
          width: 3,
          height: cellSize + 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          color: p.red,
        ));
      }
      groups.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = start; i < end; i++)
            Container(
              width: cellSize,
              height: cellSize,
              margin: EdgeInsets.only(right: i < end - 1 ? _cellGap : 0),
              decoration: BoxDecoration(
                color: i < missedPeriods ? p.red : p.cellEmpty,
                borderRadius: BorderRadius.circular(cellSize / 6),
              ),
            ),
        ],
      ));
    }

    return Semantics(
      label: '$missedPeriods de $allowed tempos de falta usados',
      child: ExcludeSemantics(
        child: Wrap(
          spacing: _groupGap,
          runSpacing: _groupGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: groups,
        ),
      ),
    );
  }
}

// Versão compacta pra lista: um traço por falta, preenchido em fração.
class AbsenceStrip extends StatelessWidget {
  final double used;
  final double limit;
  final Color color;

  const AbsenceStrip({
    super.key,
    required this.used,
    required this.limit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final slots = limit.ceil();

    if (slots <= 0 || slots > 40) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0,
          minHeight: 6,
          backgroundColor: p.cellEmpty,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }

    return Row(
      children: [
        for (var i = 0; i < slots; i++)
          Expanded(
            child: Container(
              height: 6,
              margin: EdgeInsets.only(right: i < slots - 1 ? 2 : 0),
              decoration: BoxDecoration(
                color: p.cellEmpty,
                borderRadius: BorderRadius.circular(1.5),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (used - i).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
