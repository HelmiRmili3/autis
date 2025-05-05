import 'package:autis/core/utils/enums/invite_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/failures.dart';
import '../../../core/params/invite/create_invite_params.dart';
import '../../../core/types/either.dart';
import '../../../core/utils/collections.dart';
import '../entitys/invite_entity.dart';

abstract class InviteRemoteDataSources {
  Future<Either<Failure, void>> sendInvite(CreateInviteParams invite);
  Future<Either<Failure, void>> acceptInvite(String inviteId);
  Future<Either<Failure, void>> rejectInvite(String inviteId);
  Future<Either<Failure, List<InviteEntity>>> fetchInvites(String doctorId);
  Future<Either<Failure, void>> deleteInvite(String code);
  Future<Either<Failure, InviteEntity>> checkInviteStatus(String patientId);
}

class InviteRemoteDataSourcesImpl implements InviteRemoteDataSources {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  InviteRemoteDataSourcesImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );
  @override
  Future<Either<Failure, void>> acceptInvite(String inviteId) async {
    try {
      await firebaseFirestore
          .collection(Collection.invites)
          .doc(inviteId)
          .update({
        'status': InviteStatus.accepted.name,
      });
      // RETURN THE null
      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to accept invite with id $inviteId : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteInvite(String inviteId) async {
    try {
      await firebaseFirestore
          .collection(Collection.invites)
          .doc(inviteId)
          .delete();
      // RETURN THE null
      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to delete invite with id $inviteId : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<InviteEntity>>> fetchInvites(
      String doctorId) async {
    try {
      // Fetch pending Invites
      final snapshot = await firebaseFirestore
          .collection(Collection.invites)
          .where("doctorId", isEqualTo: doctorId)
          .where("status", isEqualTo: InviteStatus.pending.name)
          .get();
      final invites = snapshot.docs.map((doc) {
        return InviteEntity.fromJson(doc.data());
      }).toList();
      // Return the pending invites List
      return Right(invites);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to fetch the pending invites : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> rejectInvite(String inviteId) async {
    try {
      await firebaseFirestore
          .collection(Collection.invites)
          .doc(inviteId)
          .update({
        'status': InviteStatus.rejected.name,
      });
      // RETURN THE null
      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to reject invite with id $inviteId : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> sendInvite(CreateInviteParams invite) async {
    try {
      // debugPrint(invite.toJson().toString());

      final InviteEntity data = InviteEntity(
        inviteId: const Uuid().v4(),
        patientId: invite.patientId,
        doctorId: invite.doctorId,
        patient: invite.patient,
        doctor: invite.doctor,
        status: InviteStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      debugPrint("error  :${data.toJson().toString()}");

      await firebaseFirestore
          .collection(Collection.invites)
          .doc(data.inviteId) // Set the document ID explicitly
          .set(data.toJson());

      // RETURN THE null
      return const Right(null);
    } catch (e) {
      debugPrint("Error : $e");
      return Left(
        FirestoreFailure('Failed to send invite : $e'),
      );
    }
  }

  @override
  Future<Either<Failure, InviteEntity>> checkInviteStatus(
      String patientId) async {
    try {
      final snapshot = await firebaseFirestore
          .collection(Collection.invites)
          .where('patientId', isEqualTo: patientId)
          .get();
      final invites = snapshot.docs.map((doc) {
        return InviteEntity.fromJson(doc.data());
      }).toList();
      debugPrint("invite ${invites.first.toJson()}");
      return Right(invites.first);
    } catch (e) {
      return Left(
        FirestoreFailure(
            "Failure fetching invite for patient with id : $patientId"),
      );
    }
  }
}
