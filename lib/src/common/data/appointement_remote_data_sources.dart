import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/appointment/create_appointment_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/factories/appointment_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/params/appointment/update_appointment_params.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/utils/collections.dart';
import '../../../injection_container.dart';
import '../entitys/appointement_entity.dart';

abstract class AppointmentRemoteDataSource {
  Future<Either<Failure, List<AppointmentEntity>>> createAppointment(
    CreateAppointmentParams appointment,
  );
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByPatient();
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByDoctor(
      String patientId);
  Future<Either<Failure, List<AppointmentEntity>>> update(
      UpdateAppointmentParams appointment);
  Future<Either<Failure, List<AppointmentEntity>>> delete(String appointmentId);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  AppointmentRemoteDataSourceImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );

  @override
  Future<Either<Failure, List<AppointmentEntity>>>
      getAppointmentsByPatient() async {
    try {
      // FETCH THE DATA FROM FIREBASE FIRESTORE
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user != null) {
        final data = await firebaseFirestore
            .collection(Collection.appointments)
            .where('patientId', isEqualTo: user.uid)
            .get();
        // MAP THE DOCS TO APPOINTMENT ENTITY LIST
        final appointments = data.docs.map((doc) {
          return AppointmentEntity.fromJson(doc.data());
        }).toList();
        debugPrint("appointmens ${appointments.toList()}");
        // RETURN THE APPOINTMENS
        return Right(appointments);
      }
      return const Left(
        FirestoreFailure('Failed to fetch appointments by patient'),
      );
    } catch (e) {
      return const Left(
        FirestoreFailure('Failed to fetch appointments by patient'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> update(
      UpdateAppointmentParams appointment) async {
    try {
      // Update Appointment
      await firebaseFirestore
          .collection(Collection.appointments)
          .doc(appointment.appointmentId)
          .update(appointment.toJson());
      // FETCH THE DATA FROM FIREBASE FIRESTORE
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user != null) {
        final data = await firebaseFirestore
            .collection(Collection.appointments)
            .where('patientId', isEqualTo: appointment.patientId)
            .where('doctorId', isEqualTo: appointment.doctorId)
            .get();
        // MAP THE DOCS TO APPOINTMENT ENTITY LIST
        final appointments = data.docs.map((doc) {
          return AppointmentEntity.fromJson(doc.data());
        }).toList();
        debugPrint("appointmens ${appointments.toList()}");
        // RETURN THE APPOINTMENS
        return Right(appointments);
      }
      return Left(
        FirestoreFailure(
            'Failed to create appointment  by patient with id ${appointment.patient.uid}'),
      );
    } catch (e) {
      return Left(
        FirestoreFailure(
            'Failed to update appointment with id ${appointment.appointmentId} by patient: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> delete(String id) async {
    try {
      await firebaseFirestore
          .collection(Collection.appointments)
          .doc(id)
          .delete();
      // FETCH THE DATA FROM FIREBASE FIRESTORE
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user != null) {
        final data = await firebaseFirestore
            .collection(Collection.appointments)
            .where('patientId', isEqualTo: user.uid)
            .get();
        // MAP THE DOCS TO APPOINTMENT ENTITY LIST
        final appointments = data.docs.map((doc) {
          return AppointmentEntity.fromJson(doc.data());
        }).toList();
        debugPrint("appointmens ${appointments.toList()}");
        // RETURN THE APPOINTMENS
        return Right(appointments);
      }
      return const Left(
        FirestoreFailure('Failed to create appointment  '),
      );
    } catch (e) {
      return Left(
        FirestoreFailure(
            'Failed to delete appointment with id  $id by patient: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByDoctor(
      String patientId) async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      // FETCH THE DATA FROM FIREBASE FIRESTORE
      if (user != null) {
        final data = await firebaseFirestore
            .collection(Collection.appointments)
            .where('doctorId', isEqualTo: user.uid)
            .where('patientId', isEqualTo: patientId)
            .get();
        // MAP THE DOCS TO APPOINTMENT ENTITY LIST
        final appointments = data.docs.map((doc) {
          return AppointmentEntity.fromJson(doc.data());
        }).toList();
        // RETURN THE APPOINTMENS
        debugPrint(appointments.toString());
        return Right(appointments);
      }
      return const Left(
        FirestoreFailure('Failed to load appointments by doctor'),
      );
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to load appointments by doctor : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> createAppointment(
      CreateAppointmentParams appointment) async {
    try {
      // FETCH THE DATA FROM FIREBASE FIRESTORE
      final AppointmentFactory appointmentData = AppointmentFactory.createNew(
        doctorId: appointment.doctorId,
        patientId: appointment.patientId,
        doctor: appointment.doctor,
        patient: appointment.patient,
        appointmentDate: appointment.appointmentDate,
      );
      debugPrint(appointmentData.toJson().toString());
      await firebaseFirestore
          .collection(Collection.appointments)
          .doc(appointmentData.appointmentId)
          .set(
            appointmentData.toJson(),
          );
      // RETURN THE null
      // FETCH THE DATA FROM FIREBASE FIRESTORE
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user != null) {
        final data = await firebaseFirestore
            .collection(Collection.appointments)
            .where('patientId', isEqualTo: user.uid)
            .get();
        // MAP THE DOCS TO APPOINTMENT ENTITY LIST
        final appointments = data.docs.map((doc) {
          return AppointmentEntity.fromJson(doc.data());
        }).toList();
        debugPrint("appointmens ${appointments.toList()}");
        // RETURN THE APPOINTMENS
        return Right(appointments);
      }
      return Left(
        FirestoreFailure(
            'Failed to create appointment  by patient with id ${appointment.patient.uid}'),
      );
    } catch (e) {
      return Left(
        FirestoreFailure(
            'Failed to create appointment  by patient with id ${appointment.patient.uid}: $e'),
      );
    }
  }
}
