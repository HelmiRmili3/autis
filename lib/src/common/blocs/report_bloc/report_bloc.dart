import 'package:autis/src/common/blocs/report_bloc/report_event.dart';
import 'package:autis/src/common/blocs/report_bloc/report_state.dart';
import 'package:autis/src/common/repository/report_repository.dart';
import 'package:bloc/bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;
  ReportBloc(
    this._reportRepository,
  ) : super(ReportInitial()) {
    on<CreateReport>(_onCreateReport);
    on<UpdateReport>(_onUpdateReport);
    on<DeleteReport>(_onDeleteReport);
    on<GetReportsForPatient>(_onGetReportsForPatient);
    on<GetReportsForDoctor>(_onGetReportsForDoctor);
  }

  void _onCreateReport(CreateReport event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await _reportRepository.createReport(event.report);
      response.fold(
        (failure) {
          emit(ReportFailure(failure.message));
        },
        (reports) {
          emit(ReportsLoaded(reports: reports));
        },
      );
    } catch (e) {
      emit(ReportFailure("Error sending invite: $e"));
    }
  }

  void _onUpdateReport(UpdateReport event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await _reportRepository.updateReport(event.report);
      response.fold(
        (failure) {
          emit(ReportFailure(failure.message));
        },
        (_) {
          // emit(ReportsLoaded([])); // Update with actual data if needed
        },
      );
    } catch (e) {
      emit(ReportFailure("Error sending invite: $e"));
    }
  }

  void _onDeleteReport(DeleteReport event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await _reportRepository.deleteReport(event.reportId);
      response.fold(
        (failure) {
          emit(ReportFailure(failure.message));
        },
        (reports) {
          emit(ReportsLoaded(reports: reports));
        },
      );
    } catch (e) {
      emit(ReportFailure("Error sending invite: $e"));
    }
  }

  void _onGetReportsForPatient(
      GetReportsForPatient event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response = await _reportRepository.fetchReportsByUserId();
      response.fold(
        (failure) {
          emit(ReportFailure(failure.message));
        },
        (reports) {
          emit(ReportsLoaded(reports: reports));
        },
      );
    } catch (e) {
      emit(ReportFailure("Error loading reports for patient: $e"));
    }
  }

  void _onGetReportsForDoctor(
      GetReportsForDoctor event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final response =
          await _reportRepository.fetchReportsByDoctorId(event.patientId);
      response.fold(
        (failure) {
          emit(ReportFailure(failure.message));
        },
        (reports) {
          emit(ReportsLoaded(reports: reports));
        },
      );
    } catch (e) {
      emit(ReportFailure("Error loading report for doctors: $e"));
    }
  }
}
