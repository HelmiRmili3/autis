import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import '../../../../core/utils/enums/gender_enum.dart';
import '../../../../core/utils/enums/role_enum.dart';
import '../../../common/models/user_model.dart';

class PatientModel extends UserModel {
  final DateTime? dateOfBirth;

  PatientModel({
    required super.uid,
    required super.email,
    required super.firstname,
    required super.lastname,
    required super.avatarUrl,
    required super.gender,
    required super.createdAt,
    required super.updatedAt,
    required super.phone,
    this.dateOfBirth,
  }) : super(
          role: Role.patient.name,
        );

  factory PatientModel.fromEntity(PatientEntity entity) {
    return PatientModel(
      uid: entity.uid,
      email: entity.email,
      firstname: entity.firstname,
      lastname: entity.lastname,
      avatarUrl: entity.avatarUrl,
      gender: entity.gender.name,
      phone: entity.phone,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      dateOfBirth: entity.dateOfBirth,
    );
  }

  PatientEntity toEntity() {
    return PatientEntity(
      uid: uid,
      email: email,
      firstname: firstname,
      lastname: lastname,
      avatarUrl: avatarUrl,
      phone: phone,
      gender: Gender.values.firstWhere(
        (e) => e.name == gender,
        orElse: () => Gender.preferNotToSay,
      ),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      dateOfBirth: dateOfBirth,
    );
  }
}
