class Doctor {
  final String id;
  final int doctorId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String? type;
  final String? qualifications;
  final String? additionalInfo;
  final String? imageUrl;

  Doctor({
    required this.id,
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    this.type,
    this.qualifications,
    this.additionalInfo,
    this.imageUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] as String,
      doctorId: json['doctorId'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      mobileNumber: json['mobileNumber'] as String,
      type: json['type'] as String?,
      qualifications: json['qualifications'] as String?,
      additionalInfo: json['additionalInfo'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      'type': type,
      'qualifications': qualifications,
      'additionalInfo': additionalInfo,
      'imageUrl': imageUrl,
    };
  }

  String get fullName => '$firstName $lastName';
}
