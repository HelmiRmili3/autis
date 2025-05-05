import 'package:autis/core/errors/failures.dart';
import 'package:autis/core/params/report/create_report_params.dart';
import 'package:autis/core/types/either.dart';

import '../entitys/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, List<ReportEntity>>> fetchAllReports();
  Future<Either<Failure, List<ReportEntity>>> fetchReportsByUserId();
  Future<Either<Failure, List<ReportEntity>>> fetchReportsByDoctorId(
      String patientId);
  Future<Either<Failure, List<ReportEntity>>> createReport(
      CreateReportParams report);
  Future<Either<Failure, List<ReportEntity>>> deleteReport(String reportId);
  Future<Either<Failure, void>> updateReport(CreateReportParams updatedReport);
  Future<Either<Failure, ReportEntity>> fetchReportById(String reportId);
}
