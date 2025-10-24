class Clinic {
  final String id;
  final int clinicId;
  final String name;
  final String address;
  final String regNo;
  final String? logo;
  final String phoneNumber;
  final double clinicFee;
  final String doctorId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Clinic({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.address,
    required this.regNo,
    this.logo,
    required this.phoneNumber,
    required this.clinicFee,
    required this.doctorId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['_id'] as String,
      clinicId: json['clinicId'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      regNo: json['regNo'] as String,
      logo: json['logo'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      clinicFee: (json['clinicFee'] as num).toDouble(),
      doctorId: json['doctor'] is String 
          ? json['doctor'] as String 
          : json['doctor']['_id'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clinicId': clinicId,
      'name': name,
      'address': address,
      'regNo': regNo,
      'logo': logo,
      'phoneNumber': phoneNumber,
      'clinicFee': clinicFee,
      'doctor': doctorId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'address': address,
      'regNo': regNo,
      'logo': logo ?? '',
      'phoneNumber': phoneNumber,
      'clinicFee': clinicFee,
      'doctor': doctorId,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'address': address,
      'regNo': regNo,
      'logo': logo ?? '',
      'phoneNumber': phoneNumber,
      'clinicFee': clinicFee,
    };
  }
}
