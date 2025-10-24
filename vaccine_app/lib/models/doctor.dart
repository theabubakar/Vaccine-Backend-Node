class Doctor {
  final String? id;
  final int? doctorId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String? type;
  final String? qualifications;
  final String? additionalInfo;
  final String? password;
  final String? image;
  final String? pmdc;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Doctor({
    this.id,
    this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    this.type,
    this.qualifications,
    this.additionalInfo,
    this.password,
    this.image,
    this.pmdc,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    try {
      return Doctor(
        id: json['_id'],
        doctorId: json['doctorId'] is int ? json['doctorId'] : (int.tryParse(json['doctorId']?.toString() ?? '0')),
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        mobileNumber: json['mobileNumber'] ?? '',
        type: json['type'],
        qualifications: json['qualifications'],
        additionalInfo: json['additionalInfo'],
        password: json['password'],
        image: json['image'],
        pmdc: json['pmdc'],
        isActive: json['isActive'] ?? true,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      );
    } catch (e) {
      print('Error parsing doctor: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (doctorId != null) 'doctorId': doctorId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      if (type != null && type!.isNotEmpty) 'type': type,
      if (qualifications != null && qualifications!.isNotEmpty) 'qualifications': qualifications,
      if (additionalInfo != null && additionalInfo!.isNotEmpty) 'additionalInfo': additionalInfo,
      if (password != null && password!.isNotEmpty) 'password': password,
      if (image != null && image!.isNotEmpty) 'image': image,
      if (pmdc != null && pmdc!.isNotEmpty) 'pmdc': pmdc,
      'isActive': isActive,
    };
  }

  Doctor copyWith({
    String? id,
    int? doctorId,
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNumber,
    String? type,
    String? qualifications,
    String? additionalInfo,
    String? password,
    String? image,
    String? pmdc,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Doctor(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      type: type ?? this.type,
      qualifications: qualifications ?? this.qualifications,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      password: password ?? this.password,
      image: image ?? this.image,
      pmdc: pmdc ?? this.pmdc,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'Doctor(id: $id, doctorId: $doctorId, fullName: $fullName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Doctor &&
        other.doctorId == doctorId &&
        other.email == email;
  }

  @override
  int get hashCode {
    return doctorId.hashCode ^ email.hashCode;
  }
}
