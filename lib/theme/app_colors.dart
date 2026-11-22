import 'package:flutter/material.dart';
import '../services/attendance_calculator.dart';

// Caneta azul no papel, falta marcada de vermelho, igual diário de chamada.
class Palette {
  final Color paper;
  final Color sheet;
  final Color ink;
  final Color inkSoft;
  final Color inkFaint;
  final Color rule;
  final Color cellEmpty;
  final Color red;
  final Color amber;
  final Color onInk;

  Color get onRed => onInk;

  const Palette({
    required this.paper,
    required this.sheet,
    required this.ink,
    required this.inkSoft,
    required this.inkFaint,
    required this.rule,
    required this.cellEmpty,
    required this.red,
    required this.amber,
    required this.onInk,
  });

  static const light = Palette(
    paper: Color(0xFFF3F5F7),
    sheet: Color(0xFFFFFFFF),
    ink: Color(0xFF1C2E5A),
    inkSoft: Color(0xFF54617D),
    inkFaint: Color(0xFF8E98AD),
    rule: Color(0xFFD5DCE8),
    cellEmpty: Color(0xFFE4E9F1),
    red: Color(0xFFCB3A3A),
    amber: Color(0xFFB7791F),
    onInk: Color(0xFFFFFFFF),
  );

  static const dark = Palette(
    paper: Color(0xFF131A29),
    sheet: Color(0xFF1A2335),
    ink: Color(0xFFDCE3F0),
    inkSoft: Color(0xFF9AA6BE),
    inkFaint: Color(0xFF66728C),
    rule: Color(0xFF29344B),
    cellEmpty: Color(0xFF253049),
    red: Color(0xFFF07070),
    amber: Color(0xFFE0A845),
    onInk: Color(0xFF131A29),
  );

  static Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  Color forStatus(AttendanceHealthStatus status) {
    switch (status) {
      case AttendanceHealthStatus.safe:
        return ink;
      case AttendanceHealthStatus.warning:
        return amber;
      case AttendanceHealthStatus.reached:
      case AttendanceHealthStatus.exceeded:
        return red;
    }
  }
}
