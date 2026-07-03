class HealthRecord {
  final int? id;
  final String userId;
  final int childId;
  final DateTime visitDate;
  final double? weight;
  final double? height;
  final double? headCircumference;
  final double? temperature;
  final int? heartRate;
  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final String? vaccinationName;
  final DateTime? vaccinationDate;
  final String? symptoms;
  final String? diagnosis;
  final String? treatment;
  final String? medications;
  final String? notes;
  final String? doctorName;
  final String? hospitalName;
  final bool isUploaded;
  final DateTime createdAt;
  final DateTime updatedAt;

  HealthRecord({
    this.id,
    required this.userId,
    required this.childId,
    required this.visitDate,
    this.weight,
    this.height,
    this.headCircumference,
    this.temperature,
    this.heartRate,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.vaccinationName,
    this.vaccinationDate,
    this.symptoms,
    this.diagnosis,
    this.treatment,
    this.medications,
    this.notes,
    this.doctorName,
    this.hospitalName,
    this.isUploaded = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'childId': childId,
      'visitDate': visitDate.toIso8601String(),
      'weight': weight,
      'height': height,
      'headCircumference': headCircumference,
      'temperature': temperature,
      'heartRate': heartRate,
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'vaccinationName': vaccinationName,
      'vaccinationDate': vaccinationDate?.toIso8601String(),
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'medications': medications,
      'notes': notes,
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'isUploaded': isUploaded ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'],
      userId: map['userId'],
      childId: map['childId'],
      visitDate: DateTime.parse(map['visitDate']),
      weight: map['weight'],
      height: map['height'],
      headCircumference: map['headCircumference'],
      temperature: map['temperature'],
      heartRate: map['heartRate'],
      bloodPressureSystolic: map['bloodPressureSystolic'],
      bloodPressureDiastolic: map['bloodPressureDiastolic'],
      vaccinationName: map['vaccinationName'],
      vaccinationDate: map['vaccinationDate'] != null 
          ? DateTime.parse(map['vaccinationDate']) 
          : null,
      symptoms: map['symptoms'],
      diagnosis: map['diagnosis'],
      treatment: map['treatment'],
      medications: map['medications'],
      notes: map['notes'],
      doctorName: map['doctorName'],
      hospitalName: map['hospitalName'],
      isUploaded: map['isUploaded'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  HealthRecord copyWith({
    int? id,
    String? userId,
    int? childId,
    DateTime? visitDate,
    double? weight,
    double? height,
    double? headCircumference,
    double? temperature,
    int? heartRate,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    String? vaccinationName,
    DateTime? vaccinationDate,
    String? symptoms,
    String? diagnosis,
    String? treatment,
    String? medications,
    String? notes,
    String? doctorName,
    String? hospitalName,
    bool? isUploaded,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      childId: childId ?? this.childId,
      visitDate: visitDate ?? this.visitDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      headCircumference: headCircumference ?? this.headCircumference,
      temperature: temperature ?? this.temperature,
      heartRate: heartRate ?? this.heartRate,
      bloodPressureSystolic: bloodPressureSystolic ?? this.bloodPressureSystolic,
      bloodPressureDiastolic: bloodPressureDiastolic ?? this.bloodPressureDiastolic,
      vaccinationName: vaccinationName ?? this.vaccinationName,
      vaccinationDate: vaccinationDate ?? this.vaccinationDate,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      doctorName: doctorName ?? this.doctorName,
      hospitalName: hospitalName ?? this.hospitalName,
      isUploaded: isUploaded ?? this.isUploaded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 