import 'package:flutter/material.dart';
import '../models/discipline.dart';
import '../services/attendance_calculator.dart';
import '../services/icon_service.dart';
import '../theme/app_colors.dart';
import 'attendance_grid.dart';

class DisciplineCard extends StatelessWidget {
  final Discipline discipline;
  final VoidCallback onTap;

  const DisciplineCard({
    super.key,
    required this.discipline,
    required this.onTap,
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
