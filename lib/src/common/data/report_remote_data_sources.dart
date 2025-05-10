import 'package:autis/core/utils/collections.dart';
import 'package:autis/src/common/factories/report_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/failures.dart';
import '../../../core/params/report/create_report_params.dart';
import '../../../core/params/report/update_report_params.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/types/either.dart';
import '../../../injection_container.dart';
import '../entitys/report_entity.dart';

abstract class ReportRemoteDataSource {
  Future<Either<Failure, List<ReportEntity>>> createReport(
    CreateReportParams report,
  );
  Future<Either<Failure, List<ReportEntity>>> getReports();
  Future<Either<Failure, List<ReportEntity>>> getReportsByDoctor(
    String patientId,
  );
  Future<Either<Failure, List<ReportEntity>>> getReportsByPatient();
  Future<Either<Failure, ReportEntity>> fetchReportById(String reportId);
  Future<Either<Failure, List<ReportEntity>>> update(UpdateReportParams report);
  Future<Either<Failure, List<ReportEntity>>> delete(String id);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  ReportRemoteDataSourceImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
  );

  @override
  Future<Either<Failure, List<ReportEntity>>> getReports() async {
    try {
      final data = await firebaseFirestore.collection(Collection.reports).get();
      final reports = data.docs.map((doc) {
        return ReportEntity.fromJson(doc.data());
      }).toList();
      return Right(reports);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to get reports: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReportsByPatient() async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user == null) {
        return const Left(
          FirestoreFailure('Failed to create report no user found'),
        );
      }
      final data = await firebaseFirestore
          .collection(Collection.reports)
          .where('patientId', isEqualTo: user.uid)
          .get();
      final reports = data.docs.map((doc) {
        return ReportEntity.fromJson(doc.data());
      }).toList();
      return Right(reports);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to get reports: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> update(
    UpdateReportParams report,
  ) async {
    final user = await sl<UserProfileStorage>().getUserProfile();
    if (user == null) {
      return const Left(
        FirestoreFailure('Failed to create report no user found'),
      );
    }
    try {
      await firebaseFirestore
          .collection(Collection.reports)
          .doc(report.reportId)
          .update({
        'reportDetails': report.reportDetails,
        'attachmentUrl': report.attachmentUrl
      });
      final data = await firebaseFirestore
          .collection(Collection.reports)
          .where('doctorId', isEqualTo: user.uid)
          .where('patientId', isEqualTo: report.patientId)
          .get();
      final reports = data.docs.map((doc) {
        return ReportEntity.fromJson(doc.data());
      }).toList();
      return Right(reports);
    } catch (e) {
      throw Exception('Failed to update report: $e');
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> delete(String id) async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user == null) {
        return const Left(
          FirestoreFailure('Failed to create report no user found'),
        );
      }

      await firebaseFirestore.collection(Collection.reports).doc(id).delete();
      final data = await firebaseFirestore
          .collection(Collection.reports)
          .where('doctorId', isEqualTo: user.uid)
          .get();
      final reports = data.docs.map((doc) {
        return ReportEntity.fromJson(doc.data());
      }).toList();
      return Right(reports);
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> createReport(
      CreateReportParams report) async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user == null) {
        return const Left(
          FirestoreFailure('Failed to create report no user found'),
        );
      }
      final ReportFactory newReport = ReportFactory.createNew(
        patientId: report.patientId,
        doctorId: report.doctorId,
        patient: report.patient,
        doctor: report.doctor,
        reportDetails: report.reportDetails,
      );
      await firebaseFirestore
          .collection(Collection.reports)
          .doc(newReport.reportId)
          .set(newReport.toJson());
      final data = await firebaseFirestore
          .collection(Collection.reports)
          .where('doctorId', isEqualTo: user.uid)
          .get();
      final reports = data.docs.map((doc) {
        return ReportEntity.fromJson(doc.data());
      }).toList();
      return Right(reports);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to create report: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReportsByDoctor(
      String patientId) async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (user == null) {
        return const Left(
          FirestoreFailure('Failed to create report no user found'),
        );
      }
      final data = await firebaseFirestore
          .collection(Collection.reports)
          .where('doctorId', isEqualTo: user.uid)
          .where('patientId', isEqualTo: patientId)
          .get();
      final reports = data.docs.map((doc) {
        return ReportEntity.fromJson(doc.data());
      }).toList();
      return Right(reports);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to get reports: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, ReportEntity>> fetchReportById(String reportId) async {
    try {
      final data = await firebaseFirestore
          .collection(Collection.reports)
          .where('reportId', isEqualTo: reportId)
          .get();
      final reports = data.docs.map((doc) {
        return ReportEntity.fromJson(doc.data());
      }).toList();
      return Right(reports.first);
    } catch (e) {
      return Left(
        FirestoreFailure('Failed to get report: $e'),
      );
    }
  }
}
