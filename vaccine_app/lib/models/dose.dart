import 'vaccine.dart';

class Dose {
  final String? id;
  final int? doseId;
  final String? name;
  final int minAge;
  final int maxAge;
  final int minGap;
  final dynamic vaccineID;
  final Vaccine? vaccine;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Dose({
    this.id,
    this.doseId,
    this.name,
    required this.minAge,
    required this.maxAge,
    this.minGap = 0,
    this.vaccineID,
    this.vaccine,
    this.createdAt,
    this.updatedAt,
  });

  factory Dose.fromJson(Map<String, dynamic> json) {
    try {
      return Dose(
        id: json['_id'],
        doseId: json['doseId'] is int ? json['doseId'] : (int.tryParse(json['doseId']?.toString() ?? '0')),
        name: json['name'],
        minAge: json['minAge'] is int ? json['minAge'] : (int.tryParse(json['minAge']?.toString() ?? '0') ?? 0),
        maxAge: json['maxAge'] is int ? json['maxAge'] : (int.tryParse(json['maxAge']?.toString() ?? '0') ?? 0),
        minGap: json['minGap'] is int ? json['minGap'] : (int.tryParse(json['minGap']?.toString() ?? '0') ?? 0),
        vaccineID: json['vaccineID'] ?? '',
        vaccine: json['vaccineID'] is Map ? Vaccine.fromJson(json['vaccineID']) : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      );
    } catch (e) {
      print('Error parsing dose: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (doseId != null) 'doseId': doseId,
      if (name != null) 'name': name,
      'minAge': minAge,
      'maxAge': maxAge,
      'minGap': minGap,
      if (vaccineID != null) 'vaccineID': vaccineID,
    };
  }

  Dose copyWith({
    String? id,
    int? doseId,
    String? name,
    int? minAge,
    int? maxAge,
    int? minGap,
    dynamic vaccineID,
    Vaccine? vaccine,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dose(
      id: id ?? this.id,
      doseId: doseId ?? this.doseId,
      name: name ?? this.name,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      minGap: minGap ?? this.minGap,
      vaccineID: vaccineID ?? this.vaccineID,
      vaccine: vaccine ?? this.vaccine,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Dose(id: $id, doseId: $doseId, minAge: $minAge, maxAge: $maxAge, minGap: $minGap, vaccineID: $vaccineID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dose &&
        other.doseId == doseId &&
        other.minAge == minAge &&
        other.maxAge == maxAge &&
        other.minGap == minGap &&
        other.vaccineID == vaccineID;
  }

  @override
  int get hashCode {
    return doseId.hashCode ^
        minAge.hashCode ^
        maxAge.hashCode ^
        minGap.hashCode ^
        vaccineID.hashCode;
  }
}

