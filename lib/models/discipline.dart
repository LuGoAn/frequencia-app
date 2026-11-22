import 'absence_record.dart';

class Discipline {
  final String id;
  final String name;
  final String iconKey;
  final int periodsPerClass;
  final int absenceLimit;
  final int? totalClasses;
  final List<AbsenceRecord> absences;
  final DateTime createdAt;

  Discipline({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.periodsPerClass,
    required this.absenceLimit,
    this.totalClasses,
    List<AbsenceRecord>? absences,
    DateTime? createdAt,
  })  : absences = absences ?? [],
        createdAt = createdAt ?? DateTime.now();

  int get totalMissedPeriods {
    return absences.fold(0, (sum, record) => sum + record.periodsCount);
  }

  int get totalExpectedPeriods {
    if (totalClasses != null && totalClasses! > 0) {
      return totalClasses!;
    }
    // sem total informado, assume que o limite é 25% da carga (regra do MEC)
    return absenceLimit * 4;
  }

  Discipline copyWith({
    String? id,
    String? name,
    String? iconKey,
    int? periodsPerClass,
    int? absenceLimit,
    int? totalClasses,
    List<AbsenceRecord>? absences,
    DateTime? createdAt,
  }) {
    return Discipline(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      periodsPerClass: periodsPerClass ?? this.periodsPerClass,
      absenceLimit: absenceLimit ?? this.absenceLimit,
      totalClasses: totalClasses ?? this.totalClasses,
      absences: absences ?? List.from(this.absences),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconKey': iconKey,
      'periodsPerClass': periodsPerClass,
      'absenceLimit': absenceLimit,
      'totalClasses': totalClasses,
      'absences': absences.map((a) => a.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Discipline.fromJson(Map<String, dynamic> json) {
    return Discipline(
      id: json['id'] as String,
      name: json['name'] as String,
      iconKey: json['iconKey'] as String? ?? 'code',
      periodsPerClass: (json['periodsPerClass'] as num?)?.toInt() ?? 2,
      absenceLimit: (json['absenceLimit'] as num?)?.round() ?? 15,
      totalClasses: (json['totalClasses'] as num?)?.toInt(),
      absences: (json['absences'] as List<dynamic>?)
              ?.map((e) => AbsenceRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
