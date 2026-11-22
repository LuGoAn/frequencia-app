import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Um quadrado por dia que dá pra faltar. Dias além do limite aparecem depois de uma barra vermelha.
class AttendanceGrid extends StatelessWidget {
  final int limit;
  final int missed;

  const AttendanceGrid({
    super.key,
    required this.limit,
    required this.missed,
  });

  static const _gap = 6.0;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final total = max(limit, missed);

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      // linhas com a mesma quantidade de quadrados, e o maior tamanho que couber
      final maxPerRow = max(1, ((w + _gap) / (26 + _gap)).floor());
      final rows = max(1, (total / maxPerRow).ceil());
      final perRow = max(1, (total / rows).ceil());
      final size = ((w - (perRow - 1) * _gap) / perRow - 0.1).clamp(14.0, 40.0);

      final cells = <Widget>[];
      for (var i = 0; i < total; i++) {
        if (i == limit && missed > limit) {
          cells.add(Container(width: 3, height: size + 6, color: p.red));
        }
        cells.add(Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: i < missed ? p.red : p.cellEmpty,
            borderRadius: BorderRadius.circular(size / 6),
          ),
        ));
      }

      return Semantics(
        label: '$missed de $limit dias de falta usados',
        child: ExcludeSemantics(
          child: Wrap(
            spacing: _gap,
            runSpacing: _gap,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: cells,
          ),
        ),
      );
    });
  }
}

// Versão compacta pra lista: um traço por dia.
class AbsenceStrip extends StatelessWidget {
  final int used;
  final int limit;
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

    if (limit <= 0 || limit > 40) {
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
        for (var i = 0; i < limit; i++)
          Expanded(
            child: Container(
              height: 6,
              margin: EdgeInsets.only(right: i < limit - 1 ? 3 : 0),
              decoration: BoxDecoration(
                color: i < used ? color : p.cellEmpty,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
      ],
    );
  }
}
