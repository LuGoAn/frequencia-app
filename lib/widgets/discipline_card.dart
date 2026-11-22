import 'package:flutter/material.dart';
import '../models/discipline.dart';
import '../services/attendance_calculator.dart';
import '../services/icon_service.dart';
import '../theme/app_colors.dart';
import 'attendance_grid.dart';

class DisciplineCard extends StatelessWidget {
  final Discipline discipline;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;

  const DisciplineCard({
    super.key,
    required this.discipline,
    required this.onTap,
    required this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final used = discipline.missedDays;
    final limit = discipline.absenceLimit;
    final status = AttendanceCalculator.getStatus(missed: used, limit: limit);
    final color = p.forStatus(status);
    final left = limit - used;
    final String subtitle;
    if (left > 0) {
      subtitle = 'Dá pra faltar mais ${AttendanceCalculator.dias(left)}';
    } else if (left == 0) {
      subtitle = 'No limite, não dá pra faltar mais';
    } else {
      subtitle = 'Passou do limite em ${AttendanceCalculator.dias(-left)}';
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                IconService.getIcon(discipline.iconKey),
                size: 24,
                color: p.inkSoft,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discipline.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                                color: p.ink,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: status == AttendanceHealthStatus.safe ? p.inkFaint : color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '$used',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w300,
                              color: color,
                              height: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: ' / $limit',
                            style: TextStyle(
                              fontSize: 14,
                              color: p.inkFaint,
                            ),
                          ),
                        ]),
                        style: const TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _QuickAddButton(onPressed: onQuickAdd),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AbsenceStrip(used: used, limit: limit, color: color),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// "+1" porque soma direto no contador do lado. X ou check dariam a ideia de excluir/concluir.
class _QuickAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _QuickAddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Tooltip(
      message: 'Registrar falta de hoje',
      child: Semantics(
        button: true,
        label: 'Registrar falta de hoje',
        child: Material(
          color: p.cellEmpty,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 44,
              height: 36,
              child: Center(
                child: ExcludeSemantics(
                  child: Text(
                    '+1',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: p.ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
