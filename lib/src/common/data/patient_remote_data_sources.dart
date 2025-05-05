import 'package:autis/core/params/patient/update_patient_params.dart';
import 'package:autis/core/utils/enums/invite_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/failures.dart';
import '../../../core/types/either.dart';
import '../../../core/utils/collections.dart';
import '../../../core/utils/enums/role_enum.dart';
import '../../patient/domain/entities/patient_entity.dart';
import '../entitys/video.dart';

abstract class PatientRemoteDataSource {
  Future<Either<Failure, List<PatientEntity>>> getPatients();
  Future<Either<Failure, List<PatientEntity>>> getPatientsByDoctor(String id);
  Future<Either<Failure, void>> update(UpdatePatientParams patient);
  Future<Either<Failure, List<PatientEntity>>> delete(String id);
  Future<Either<Failure, List<Video>>> getVediosByPatient(String id);
  Future<Either<Failure, List<Video>>> addVediosByPatient(Video vedio);
  Future<Either<Failure, List<Video>>> deleteVediosByPatient(String id);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  PatientRemoteDataSourceImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );
  @override
  Future<Either<Failure, List<PatientEntity>>> getPatients() async {
    try {
      // Fetch Patients
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .where("role", isNotEqualTo: Role.admin.name)
          .get();
      final patients = snapshot.docs.map((doc) {
        return PatientEntity.fromJson(doc.data());
      }).toList();
      // RETURN THE Patients List
      return Right(patients);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch patients : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<PatientEntity>>> getPatientsByDoctor(
      String doctorId) async {
    try {
      final snapshot = await firebaseFirestore
          .collection(Collection.invites)
          .where("doctorId", isEqualTo: doctorId)
          .where("status", isEqualTo: InviteStatus.accepted.name)
          .get();

      final patients = snapshot.docs.map((doc) {
        final data = doc.data();
        return PatientEntity.fromJson(data["patient"]);
      }).toList();

      return Right(patients);
    } catch (e) {
      return Left(FirestoreFailure('Failed to fetch patients: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> update(UpdatePatientParams patient) async {
    try {
      // Update Doctor
      await firebaseFirestore
          .collection(Collection.users)
          .doc(patient.uid)
          .update(patient.toJson());
      // RETURN THE null
      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure(
            'Failed to Update patient  with id ${patient.uid} : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<PatientEntity>>> delete(String patientId) async {
    try {
      // Delete Patient
      await firebaseFirestore
          .collection(Collection.users)
          .doc(patientId)
          .delete();
      final snapshot = await firebaseFirestore
          .collection(Collection.users)
          .where("role", isEqualTo: Role.patient.name)
          .get();

      final patients = snapshot.docs.map((doc) {
        final data = doc.data();
        return PatientEntity.fromJson(data);
      }).toList();

      return Right(patients);
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        FirestoreFailure('Failed to delete patient  with id $patientId : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Video>>> addVediosByPatient(Video vedio) async {
    try {
      // Add Vedio
      await firebaseFirestore
          .collection(Collection.videos)
          .doc(vedio.id)
          .set(vedio.toJson());
      // fetch vedios
      final snapshot =
          await firebaseFirestore.collection(Collection.videos).get();
      final vedios = snapshot.docs.map((doc) {
        return Video.fromJson(doc.data());
      }).toList();
      // RETURN THE Patients List
      debugPrint(snapshot.toString());
      return Right(vedios);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch patients : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Video>>> deleteVediosByPatient(String id) async {
    try {
      // delete Vedio
      await firebaseFirestore.collection(Collection.videos).doc(id).delete();
      // fetch vedios
      final snapshot =
          await firebaseFirestore.collection(Collection.videos).get();
      final vedios = snapshot.docs.map((doc) {
        return Video.fromJson(doc.data());
      }).toList();
      // RETURN THE Patients List
      return Right(vedios);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch patients : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Video>>> getVediosByPatient(String id) async {
    try {
      // fetch vedios
      final snapshot = await firebaseFirestore
          .collection(Collection.videos)
          .where('patientId', isEqualTo: id)
          .get();
      final vedios = snapshot.docs.map((doc) {
        return Video.fromJson(doc.data());
      }).toList();
      // RETURN THE Patients List
      return Right(vedios);
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        FirestoreFailure('Failed to fetch patients : $e'),
      );
    }
  }
}
