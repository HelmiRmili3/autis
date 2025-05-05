import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/failures.dart';
import '../../../core/params/profile/update_user_params.dart';
import '../../../core/types/either.dart';
import '../../../core/utils/collections.dart';
import '../../patient/domain/entities/patient_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserEntity>> getProfile(String userId);
  Future<Either<Failure, void>> update(UpdateUserProfile profile);
  Future<Either<Failure, void>> delete(String id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  ProfileRemoteDataSourceImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );

  @override
  Future<Either<Failure, UserEntity>> getProfile(String userId) async {
    try {
      // Fetch Patients
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(userId)
          .get();
      final patient = PatientEntity.fromJson(snapshot.data()!);
      return Right(patient);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch patients : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> update(UpdateUserProfile profile) async {
    try {
      await firebaseFirestore
          .collection(Collection.users)
          .doc(profile.uid)
          .update(profile.toJson());
      return const Right(null);
    } catch (e) {
      return Left(
          FirestoreFailure('Failed to update user with ${profile.uid} : $e'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String userId) async {
    try {
      // Fetch Patients
      await firebaseFirestore.collection(Collection.users).doc(userId).delete();
      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to delete patient : $e'),
      );
    }
  }
}
