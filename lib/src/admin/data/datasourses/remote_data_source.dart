import 'package:autis/core/errors/failures.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:autis/src/common/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/types/either.dart';

abstract class AdminRemoteDataSource {
  Future<Either<Failure, UserModel>> acceptDoctorInv(String uid);
  Future<Either<Failure, UserModel>> rejectDoctorInv(String uid);
  Future<Either<Failure, List<UserEntity>>> fetchUsers(List<String> filter);
  Future<Either<Failure, List<UserEntity>>> fetchDoctors(String uid);
  Future<Either<Failure, List<UserEntity>>> fetchPatients(String uid);
  Future<Either<Failure, UserModel>> fetchUserById(String uid);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AdminRemoteDataSourceImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );
  @override
  Future<Either<Failure, UserModel>> acceptDoctorInv(String uid) {
    // TODO: implement acceptDoctorInv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> rejectDoctorInv(String uid) {
    // TODO: implement rejectDoctorInv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserEntity>>> fetchDoctors(String uid) {
    // TODO: implement fetchDoctors
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserEntity>>> fetchPatients(String uid) {
    // TODO: implement fetchPatients
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> fetchUserById(String uid) {
    // TODO: implement fetchUserById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserEntity>>> fetchUsers(List<String> filter) {
    // TODO: implement fetchUsers
    throw UnimplementedError();
  }
}
