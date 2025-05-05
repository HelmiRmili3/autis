import 'package:autis/src/common/entitys/report_entity.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportsLoaded extends ReportState {
  final List<ReportEntity> reports;
  ReportsLoaded({required this.reports});
}

class ReportFailure extends ReportState {
  final String error;
  ReportFailure(this.error);
}
