import 'package:flutter/material.dart';
import '../models/absence_record.dart';
import '../models/discipline.dart';
import '../services/attendance_calculator.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Discipline> _disciplines = [];
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  List<Discipline> get disciplines => List.unmodifiable(_disciplines);
  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  int get totalDisciplines => _disciplines.length;

  double get averageFrequency {
    if (_disciplines.isEmpty) return 100.0;
    final total = _disciplines.fold<double>(0.0, (sum, d) {
      final pct = AttendanceCalculator.frequencyPercentage(
        missed: d.missedDays,
        totalClasses: d.totalExpectedClasses,
      );
      return sum + pct;
    });
    return total / _disciplines.length;
  }

  int get disciplinesAtRisk {
    return _disciplines.where((d) {
      final status = AttendanceCalculator.getStatus(
        missed: d.missedDays,
        limit: d.absenceLimit,
      );
      return status == AttendanceHealthStatus.warning ||
          status == AttendanceHealthStatus.reached ||
          status == AttendanceHealthStatus.exceeded;
    }).length;
  }

  Future<void> init() async {
    _themeMode = await _storageService.loadThemeMode();
    _disciplines = await _storageService.loadDisciplines();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _storageService.saveThemeMode(_themeMode);
  }

  Discipline? getDisciplineById(String id) {
    try {
      return _disciplines.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addDiscipline(Discipline discipline) async {
    _disciplines.insert(0, discipline);
    notifyListeners();
    await _storageService.saveDisciplines(_disciplines);
  }

  Future<void> updateDiscipline(Discipline updated) async {
    final index = _disciplines.indexWhere((d) => d.id == updated.id);
    if (index != -1) {
      _disciplines[index] = updated;
      notifyListeners();
      await _storageService.saveDisciplines(_disciplines);
    }
  }

  Future<void> deleteDiscipline(String id) async {
    _disciplines.removeWhere((d) => d.id == id);
    notifyListeners();
    await _storageService.saveDisciplines(_disciplines);
  }

  Future<void> addAbsence(String disciplineId, AbsenceRecord record) async {
    final index = _disciplines.indexWhere((d) => d.id == disciplineId);
    if (index != -1) {
      final current = _disciplines[index];
      final updatedAbsences = [record, ...current.absences];
      updatedAbsences.sort((a, b) => b.date.compareTo(a.date));
      _disciplines[index] = current.copyWith(absences: updatedAbsences);
      notifyListeners();
      await _storageService.saveDisciplines(_disciplines);
    }
  }

  Future<void> updateAbsence(String disciplineId, AbsenceRecord updatedRecord) async {
    final index = _disciplines.indexWhere((d) => d.id == disciplineId);
    if (index != -1) {
      final current = _disciplines[index];
      final recordIndex =
          current.absences.indexWhere((a) => a.id == updatedRecord.id);
      if (recordIndex != -1) {
        final updatedList = List<AbsenceRecord>.from(current.absences);
        updatedList[recordIndex] = updatedRecord;
        updatedList.sort((a, b) => b.date.compareTo(a.date));
        _disciplines[index] = current.copyWith(absences: updatedList);
        notifyListeners();
        await _storageService.saveDisciplines(_disciplines);
      }
    }
  }

  Future<void> deleteAbsence(String disciplineId, String recordId) async {
    final index = _disciplines.indexWhere((d) => d.id == disciplineId);
    if (index != -1) {
      final current = _disciplines[index];
      final updatedList =
          current.absences.where((a) => a.id != recordId).toList();
      _disciplines[index] = current.copyWith(absences: updatedList);
      notifyListeners();
      await _storageService.saveDisciplines(_disciplines);
    }
  }
}
