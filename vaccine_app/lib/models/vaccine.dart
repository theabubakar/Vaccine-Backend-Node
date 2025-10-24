class Vaccine {
  final String? id;
  final int? vaccineID;
  final String name;
  final int minAge;
  final int maxAge;
  final bool isInfinite;
  final bool validity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vaccine({
    this.id,
    this.vaccineID,
    required this.name,
    required this.minAge,
    required this.maxAge,
    this.isInfinite = false,
    this.validity = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    try {
      return Vaccine(
        id: json['_id'],
        vaccineID: json['vaccineID'] is int ? json['vaccineID'] : (int.tryParse(json['vaccineID']?.toString() ?? '0')),
        name: json['name'] ?? '',
        minAge: json['minAge'] is int ? json['minAge'] : (int.tryParse(json['minAge']?.toString() ?? '0') ?? 0),
        maxAge: json['maxAge'] is int ? json['maxAge'] : (int.tryParse(json['maxAge']?.toString() ?? '0') ?? 0),
        isInfinite: json['isInfinite'] ?? false,
        validity: json['validity'] ?? true,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      );
    } catch (e) {
      print('Error parsing vaccine: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (vaccineID != null) 'vaccineID': vaccineID,
      'name': name,
      'minAge': minAge,
      'maxAge': maxAge,
      'isInfinite': isInfinite,
      'validity': validity,
    };
  }

  Vaccine copyWith({
    String? id,
    int? vaccineID,
    String? name,
    int? minAge,
    int? maxAge,
    bool? isInfinite,
    bool? validity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vaccine(
      id: id ?? this.id,
      vaccineID: vaccineID ?? this.vaccineID,
      name: name ?? this.name,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      isInfinite: isInfinite ?? this.isInfinite,
      validity: validity ?? this.validity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Vaccine(id: $id, vaccineID: $vaccineID, name: $name, minAge: $minAge, maxAge: $maxAge, isInfinite: $isInfinite, validity: $validity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vaccine &&
        other.vaccineID == vaccineID &&
        other.name == name &&
        other.minAge == minAge &&
        other.maxAge == maxAge &&
        other.isInfinite == isInfinite &&
        other.validity == validity;
  }

  @override
  int get hashCode {
    return vaccineID.hashCode ^
        name.hashCode ^
        minAge.hashCode ^
        maxAge.hashCode ^
        isInfinite.hashCode ^
        validity.hashCode;
  }
}
