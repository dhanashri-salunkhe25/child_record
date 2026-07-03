class Child {
  final int? id;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String parentName;
  final String contactNumber;
  final String address;
  final String village;
  final String district;
  final String state;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  Child({
    this.id,
    required this.userId,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.parentName,
    required this.contactNumber,
    required this.address,
    required this.village,
    required this.district,
    required this.state,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'parentName': parentName,
      'contactNumber': contactNumber,
      'address': address,
      'village': village,
      'district': district,
      'state': state,
      'photoPath': photoPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
      parentName: map['parentName'],
      contactNumber: map['contactNumber'],
      address: map['address'],
      village: map['village'],
      district: map['district'],
      state: map['state'],
      photoPath: map['photoPath'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Child copyWith({
    int? id,
    String? userId,
    String? name,
    String? dateOfBirth,
    String? gender,
    String? parentName,
    String? contactNumber,
    String? address,
    String? village,
    String? district,
    String? state,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Child(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      parentName: parentName ?? this.parentName,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      village: village ?? this.village,
      district: district ?? this.district,
      state: state ?? this.state,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 