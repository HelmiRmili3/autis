import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/authentication/create_user_params.dart';
import 'package:autis/core/params/authentication/login_user_params.dart';
import 'package:autis/core/utils/collections.dart';
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/types/either.dart';
import '../../../core/utils/enums/role_enum.dart';
import '../entitys/user_entity.dart';

abstract class AuthRemoteDataSource {
  // Authentication related data sources
  Future<Either<Failure, void>> login(Loginuserprams user);
  Future<Either<Failure, UserCredential>> register(Loginuserprams user);
  Future<Either<Failure, UserEntity>> create(CreateUserParams user);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteAccount(String uid);
  // User profile related data sources
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, void>> updateUserProfile(UserEntity user);
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AuthRemoteDataSourcesImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );
  @override
  Future<Either<FirebaseAuthFailure, void>> login(Loginuserprams user) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return const Right(null);
    } catch (e) {
      return Left(FirebaseAuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(FirebaseAuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> register(Loginuserprams user) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return Right(userCredential);
    } catch (e) {
      return Left(FirebaseAuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String uid) async {
    try {
      await firebaseAuth.currentUser?.delete();
      await firebaseFirestore.collection(Collection.users).doc(uid).delete();
      return const Right(null);
    } catch (e) {
      return Left(FirebaseAuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> create(
    CreateUserParams user,
  ) async {
    try {
      if (user.role == Role.doctor) {
        final DoctorEntity doctorData = DoctorEntity(
          uid: user.uid!,
          email: user.email,
          firstname: user.firstName,
          lastname: user.lastName,
          avatarUrl:
              "https://img.freepik.com/free-psd/3d-illustration-with-online-avatar_23-2151303097.jpg?ga=GA1.1.1885085166.1740484951&semt=ais_hybrid&w=740",
          gender: user.gender,
          phone: user.phone,
          licenseNumber: "licenseNumber",
          specialization: "specialization",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await firebaseFirestore
            .collection(Collection.users)
            .doc(doctorData.uid)
            .set(doctorData.toJson());
        return Right(doctorData);
      }
      final UserEntity userdata = UserEntity(
        uid: user.uid!,
        email: user.email,
        phone: user.phone,
        firstname: user.firstName,
        lastname: user.lastName,
        gender: user.gender,
        avatarUrl:
            "https://img.freepik.com/free-psd/3d-illustration-with-online-avatar_23-2151303097.jpg?ga=GA1.1.1885085166.1740484951&semt=ais_hybrid&w=740",
        role: user.role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await firebaseFirestore
          .collection(Collection.users)
          .doc(userdata.uid)
          .set(userdata.toMap());
      return Right(userdata);
    } catch (e) {
      return Left(FirebaseAuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      // 1. Safely get current user
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return const Left(FirebaseAuthFailure("No authenticated user"));
      }

      // 2. Get user document
      final docSnapshot = await firebaseFirestore
          .collection(Collection.users)
          .doc(currentUser.uid)
          .get();

      // 3. Check if document exists and has data
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return const Left(FirebaseAuthFailure("User profile not found"));
      }

      // 4. Safely parse user data
      final user = UserEntity.fromMap(docSnapshot.data()!);
      return Right(user);
    } on FirebaseException catch (e) {
      return Left(FirebaseAuthFailure(e.message ?? "Firebase error occurred"));
    } catch (e) {
      return Left(FirebaseAuthFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserEntity user) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
