import 'package:autis/core/params/report/create_report_params.dart';

import '../../../../core/params/report/update_report_params.dart';

abstract class ReportEvent {}

class CreateReport extends ReportEvent {
  final CreateReportParams report;
  CreateReport(this.report);
}

class UpdateReport extends ReportEvent {
  final UpdateReportParams report;
  UpdateReport(this.report);
}

class DeleteReport extends ReportEvent {
  final String reportId;
  DeleteReport(this.reportId);
}

class GetReportsForPatient extends ReportEvent {
  GetReportsForPatient();
}

class GetReportsForDoctor extends ReportEvent {
  final String patientId;
  GetReportsForDoctor(this.patientId);
}
