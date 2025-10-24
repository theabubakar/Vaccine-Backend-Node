class Brand {
  final String? id;
  final int? brandId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Brand({
    this.id,
    this.brandId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    try {
      return Brand(
        id: json['_id'],
        brandId: json['brandId'] is int ? json['brandId'] : (int.tryParse(json['brandId']?.toString() ?? '0')),
        name: json['name'] ?? '',
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      );
    } catch (e) {
      print('Error parsing brand: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (brandId != null) 'brandId': brandId,
      'name': name,
    };
  }

  Brand copyWith({
    String? id,
    int? brandId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Brand(id: $id, brandId: $brandId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Brand &&
        other.brandId == brandId &&
        other.name == name;
  }

  @override
  int get hashCode {
    return brandId.hashCode ^ name.hashCode;
  }
}
