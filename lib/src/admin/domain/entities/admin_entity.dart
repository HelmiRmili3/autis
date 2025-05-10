import '../../../../core/utils/enums/role_enum.dart';
import '../../../common/entitys/user_entity.dart';

class AdminEntity extends UserEntity {
  const AdminEntity({
    required super.uid,
    required super.email,
    required super.firstname,
    required super.lastname,
    required super.avatarUrl,
    required super.gender,
    required super.phone,
    required super.dateOfBirth,
    required super.createdAt,
    required super.updatedAt,
  }) : super(role: Role.admin);
}
