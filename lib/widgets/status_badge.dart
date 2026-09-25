import 'package:flutter/material.dart';
import '../services/attendance_calculator.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final AttendanceHealthStatus status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color fg;
    Color bg;
    Color border;
    String label;
    IconData icon;

    switch (status) {
      case AttendanceHealthStatus.safe:
        fg = isDark ? AppColors.darkSafeGreen : AppColors.safeGreen;
        bg = isDark ? AppColors.darkSafeGreenBg : AppColors.safeGreenBg;
        border = isDark ? Colors.transparent : AppColors.safeGreenBorder;
        label = 'Regular';
        icon = Icons.check_circle_outline_rounded;
        break;
      case AttendanceHealthStatus.warning:
        fg = isDark ? AppColors.darkWarningAmber : AppColors.warningAmber;
        bg = isDark ? AppColors.darkWarningAmberBg : AppColors.warningAmberBg;
        border = isDark ? Colors.transparent : AppColors.warningAmberBorder;
        label = 'Atenção';
        icon = Icons.error_outline_rounded;
        break;
      case AttendanceHealthStatus.reached:
        fg = isDark ? AppColors.darkAlertRose : AppColors.alertRose;
        bg = isDark ? AppColors.darkAlertRoseBg : AppColors.alertRoseBg;
        border = isDark ? Colors.transparent : AppColors.alertRoseBorder;
        label = 'No limite';
        icon = Icons.warning_amber_rounded;
        break;
      case AttendanceHealthStatus.exceeded:
        fg = isDark ? AppColors.darkAlertRose : AppColors.alertRose;
        bg = isDark ? AppColors.darkAlertRoseBg : AppColors.alertRoseBg;
        border = isDark ? Colors.transparent : AppColors.alertRoseBorder;
        label = 'Limite excedido';
        icon = Icons.cancel_outlined;
        break;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
