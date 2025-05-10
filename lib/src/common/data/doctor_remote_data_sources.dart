import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/services/secure_storage_service.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/utils/collections.dart';
import '../../../core/utils/enums/role_enum.dart';
import '../../../injection_container.dart';
import '../../doctor/domain/entities/doctor_entity.dart';
import '../../doctor/domain/entities/update_doctor_params.dart';

abstract class DoctorRemoteDataSource {
  Future<Either<Failure, List<DoctorEntity>>> fetchAllDoctors();
  Future<Either<Failure, DoctorEntity>> fetchDoctorById(String doctorId);
  Future<Either<Failure, void>> verifyDoctor(String id, bool isVerified);
  Future<Either<Failure, void>> deleteDoctor(String doctorId);
  Future<Either<Failure, DoctorEntity>> updateDoctor(UpdateDoctorParams doctor);
  Future<Either<Failure, List<DoctorEntity>>> fetchVerifiedDoctors();
  Future<Either<Failure, List<DoctorEntity>>> fetchUnVerifiedDoctors();
  Future<Either<Failure, bool>> checkDoctorVerified(String doctorId);
}

class DoctorRemoteDataSourcesImpl implements DoctorRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  DoctorRemoteDataSourcesImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );
  @override
  Future<Either<Failure, void>> deleteDoctor(String doctorId) async {
    try {
      // Delete Doctor
      await firebaseFirestore
          .collection(Collection.users)
          .doc(doctorId)
          .delete();
      // RETURN THE null
      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to delete doctor  with id $doctorId : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> fetchAllDoctors() async {
    try {
      // Fetch Doctors
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .where("role", isEqualTo: Role.doctor)
          .get();
      final doctors = snapshot.docs.map((doc) {
        return DoctorEntity.fromJson(doc.data());
      }).toList();
      // RETURN THE Doctors List
      return Right(doctors);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch doctors : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> fetchDoctorById(String doctorId) async {
    try {
      // Fetch Doctor by id
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(doctorId)
          .get();
      final doctor = DoctorEntity.fromJson(snapshot.data()!);
      // RETURN THE Doctor
      return Right(doctor);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch doctor by id $doctorId : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> verifyDoctor(String id, bool isVerified) async {
    try {
      // Verifié Doctor
      await firebaseFirestore.collection(Collection.users).doc(id).update({
        'isVerified': isVerified,
      });
      // RETURN THE NULL
      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure(
            'Failed to change the verfication state for the doctor with id $id : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkDoctorVerified(String doctorId) async {
    try {
      // Verifié Doctor
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(doctorId)
          .get();
      final doctor = DoctorEntity.fromJson(snapshot.data()!);
      // Return bool (true) if the doctor is verified and false otherwise
      return Right(doctor.isVerified);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to check if the user is  Verified  : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> fetchUnVerifiedDoctors() async {
    try {
      // Fetch UnVerified Doctors
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .where("role", isEqualTo: Role.doctor.name)
          .where("isVerified", isEqualTo: false)
          .get();
      final doctors = snapshot.docs.map((doc) {
        return DoctorEntity.fromJson(doc.data());
      }).toList();
      // RETURN THE UnVerified Doctors List
      return Right(doctors);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch UnVerified doctors : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> fetchVerifiedDoctors() async {
    try {
      // Fetch verified Doctors
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .where("role", isEqualTo: Role.doctor.name)
          .where("isVerified", isEqualTo: true)
          .get();
      final doctors = snapshot.docs.map((doc) {
        return DoctorEntity.fromJson(doc.data());
      }).toList();
      // RETURN THE verified Doctors List
      return Right(doctors);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch verified doctors : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> updateDoctor(
      UpdateDoctorParams doctor) async {
    try {
      // Update Doctor
      await firebaseFirestore
          .collection(Collection.users)
          .doc(doctor.doctorId)
          .update(doctor.toJson());
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(doctor.doctorId)
          .get();
      final data = DoctorEntity.fromJson(snapshot.data()!);
      sl<UserProfileStorage>().saveUserProfile(UserEntity(
        uid: data.uid,
        email: data.email,
        firstname: data.firstname,
        lastname: data.lastname,
        avatarUrl: data.avatarUrl,
        dateOfBirth: data.dateOfBirth,
        gender: data.gender,
        phone: data.phone,
        role: data.role,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      ));
      // RETURN THE null
      return Right(data);
    } catch (e) {
      return Left(
        FirestoreFailure(
            'Failed to Update doctor  with id ${doctor.doctorId} : $e'),
      );
    }
  }
}
