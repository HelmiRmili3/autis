import '../../../../core/utils/enums/gender_enum.dart';
import '../../../../core/utils/enums/role_enum.dart';
import '../../../common/models/user_model.dart';
import '../../domain/entities/doctor_entity.dart';

class DoctorModel extends UserModel {
  final String licenseNumber;
  final String? specialization;
  final List<String>? availableDays;

  DoctorModel({
    required super.uid,
    required super.email,
    required super.firstname,
    required super.lastname,
    required super.avatarUrl,
    required super.gender,
    required super.phone,
    required super.createdAt,
    required super.updatedAt,
    required this.licenseNumber,
    this.specialization,
    this.availableDays,
  }) : super(
          role: Role.doctor.name,
        );

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      uid: entity.uid,
      email: entity.email,
      firstname: entity.firstname,
      lastname: entity.lastname,
      avatarUrl: entity.avatarUrl,
      gender: entity.gender.name,
      phone: entity.phone,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      licenseNumber: entity.licenseNumber,
    );
  }

  DoctorEntity toEntity() {
    return DoctorEntity(
      uid: uid,
      email: email,
      firstname: firstname,
      lastname: lastname,
      avatarUrl: avatarUrl,
      gender: Gender.values.firstWhere(
        (e) => e.name == gender,
        orElse: () => Gender.preferNotToSay,
      ),
      phone: phone,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      licenseNumber: licenseNumber,
      specialization: specialization,
    );
  }
}
