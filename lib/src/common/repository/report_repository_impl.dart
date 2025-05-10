import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/report/create_report_params.dart';
import 'package:autis/core/types/either.dart';
import 'package:autis/src/common/data/report_remote_data_sources.dart';
import 'package:autis/src/common/entitys/report_entity.dart';
import 'package:autis/src/common/repository/report_repository.dart';

import '../../../core/params/report/update_report_params.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  ReportRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<ReportEntity>>> createReport(
      CreateReportParams report) {
    return remoteDataSource.createReport(report);
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> deleteReport(String reportId) {
    return remoteDataSource.delete(reportId);
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> fetchAllReports() {
    return remoteDataSource.getReports();
  }

  @override
  Future<Either<Failure, ReportEntity>> fetchReportById(String reportId) {
    return remoteDataSource.fetchReportById(reportId);
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> fetchReportsByDoctorId(
      String patientId) {
    return remoteDataSource.getReportsByDoctor(patientId);
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> fetchReportsByUserId() {
    return remoteDataSource.getReportsByPatient();
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> updateReport(
      UpdateReportParams updatedReport) {
    return remoteDataSource.update(updatedReport);
  }
}
