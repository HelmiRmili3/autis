import 'package:autis/src/common/blocs/appointement_bloc/appointement_event.dart';
import 'package:autis/src/common/blocs/appointement_bloc/appointement_state.dart';
import 'package:autis/src/common/repository/appointement_repository.dart';
import 'package:bloc/bloc.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;

  AppointmentBloc(
    this.appointmentRepository,
  ) : super(AppointmentInitial()) {
    on<CreatedAppointement>(_onAppointementCreated);
    on<UpdatedAppointement>(_onAppointementUpdated);
    on<DeletedAppointement>(_onAppointementDeleted);
    on<GetDoctorAppointements>(_onGetDoctorAppointements);
    on<GetPatientAppointements>(_onGetPatientAppointements);
  }

  Future<void> _onAppointementCreated(
      CreatedAppointement event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final response =
          await appointmentRepository.createAppointement(event.appointement);
      response.fold(
        (failure) => emit(AppointmentFailure(
            "Failed to create appointment: ${failure.message}")),
        (appointments) => emit(AppointmentLoaded(appointments)),
      );
    } catch (e) {
      emit(AppointmentFailure(
          "Unexpected error creating appointment: ${e.toString()}"));
    }
  }

  Future<void> _onAppointementUpdated(
      UpdatedAppointement event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final response =
          await appointmentRepository.updateAppointement(event.appointement);
      response.fold(
        (failure) => emit(AppointmentFailure(
            "Failed to update appointment: ${failure.message}")),
        (appointments) => emit(AppointmentLoaded(appointments)),
      );
    } catch (e) {
      emit(AppointmentFailure(
          "Unexpected error updating appointment: ${e.toString()}"));
    }
  }

  Future<void> _onAppointementDeleted(
      DeletedAppointement event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final response =
          await appointmentRepository.deleteAppointement(event.appointementId);
      response.fold(
        (failure) => emit(AppointmentFailure(
          "Failed to delete appointment: ${failure.message}",
        )),
        (appointments) => emit(AppointmentLoaded(appointments)),
      );
    } catch (e) {
      emit(AppointmentFailure(
          "Unexpected error deleting appointment ID ${event.appointementId}: ${e.toString()}"));
    }
  }

  Future<void> _onGetDoctorAppointements(
      GetDoctorAppointements event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final response = await appointmentRepository
          .fetchAppointementsForDoctor(event.patientId);
      response.fold(
        (failure) => emit(
          AppointmentFailure(
            "Failed to load doctor appointments: ${failure.message}",
          ),
        ),
        (appointments) => emit(AppointmentLoaded(appointments)),
      );
    } catch (e) {
      emit(
        AppointmentFailure(
          "Unexpected error loading doctor appointments: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onGetPatientAppointements(
      GetPatientAppointements event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());

    try {
      final response =
          await appointmentRepository.fetchAppointementByPatientId();
      response.fold(
        (failure) {
          emit(AppointmentFailure(
              "Failed to load patient appointments: ${failure.message}"));
        },
        (appointments) {
          emit(AppointmentLoaded(appointments));
        },
      );
    } catch (e) {
      emit(AppointmentFailure(
          "Unexpected error loading patient appointments: ${e.toString()}"));
    }
  }
}
