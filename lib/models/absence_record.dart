class AbsenceRecord {
  final String id;
  final DateTime date;
  final List<int> missedPeriods;
  final String? note;
  final DateTime createdAt;

  AbsenceRecord({
    required this.id,
    required this.date,
    required this.missedPeriods,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get periodsCount => missedPeriods.length;

  AbsenceRecord copyWith({
    String? id,
    DateTime? date,
    List<int>? missedPeriods,
    String? note,
    DateTime? createdAt,
  }) {
    return AbsenceRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      missedPeriods: missedPeriods ?? List.from(this.missedPeriods),
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'missedPeriods': missedPeriods,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AbsenceRecord.fromJson(Map<String, dynamic> json) {
    return AbsenceRecord(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      missedPeriods: (json['missedPeriods'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
