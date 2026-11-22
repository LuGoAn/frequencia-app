import 'package:flutter/material.dart';
import '../services/attendance_calculator.dart';
import '../theme/app_colors.dart';

String statusLabel(AttendanceHealthStatus status) {
  switch (status) {
    case AttendanceHealthStatus.safe:
      return 'Em dia';
    case AttendanceHealthStatus.warning:
      return 'Perto do limite';
    case AttendanceHealthStatus.reached:
      return 'No limite';
    case AttendanceHealthStatus.exceeded:
      return 'Passou do limite';
  }
}

class StatusBadge extends StatelessWidget {
  final AttendanceHealthStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final color = status == AttendanceHealthStatus.safe
        ? p.inkSoft
        : p.forStatus(status);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          statusLabel(status),
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
