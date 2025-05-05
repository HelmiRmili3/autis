import 'package:autis/src/common/blocs/doctor_bloc/doctor_event.dart';
import 'package:autis/src/common/blocs/doctor_bloc/doctor_state.dart';
import 'package:autis/src/common/repository/doctor_repository.dart';
import 'package:bloc/bloc.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository doctorRepository;

  DoctorBloc(
    this.doctorRepository,
  ) : super(DoctorInitial()) {
    on<FetchDoctor>(_onFetchDoctor);
    on<UpdateDoctor>(_onUpdateDoctor);
    on<DeleteDoctor>(_onDeleteDoctor);
    on<FetchVerifiedDoctors>(_onFetchVerifiedDoctors);
    on<FetchUnverifiedDoctors>(_onFetchUnverifiedDoctors);
    on<VerifyDoctor>(_onVerifyDoctor);
  }
  Future<void> _onVerifyDoctor(
      VerifyDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      await doctorRepository.verifyDoctor(event.id, event.isVerified);
      final response = await doctorRepository.fetchUnVerifiedDoctors();
      response.fold(
        (failure) => emit(DoctorError("Error unverified doctors: $failure")),
        (doctors) => emit(DoctorsLoaded(doctors)),
      );
    } catch (e) {
      emit(DoctorError("Error fetching doctor: $e"));
    }
  }

  Future<void> _onFetchDoctor(
      FetchDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final response = await doctorRepository.fetchDoctorById(event.doctorId);
      response.fold(
        (failure) => emit(DoctorError("Error fetching doctor: $failure")),
        (doctorEntity) {
          emit(DoctorLoaded(doctorEntity));
        },
      );
    } catch (e) {
      emit(DoctorError("Error fetching doctor: $e"));
    }
  }

  Future<void> _onUpdateDoctor(
      UpdateDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final response = await doctorRepository.updateDoctor(event.doctorEntity);
      response.fold(
        (failure) => emit(DoctorError("Error updating doctor: $failure")),
        (success) => emit(DoctorUpdated("Doctor updated successfully")),
      );
    } catch (e) {
      emit(DoctorError("Error updating doctor: $e"));
    }
  }

  Future<void> _onDeleteDoctor(
      DeleteDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final response = await doctorRepository.deleteDoctor(event.doctorId);
      response.fold(
        (failure) => emit(DoctorError("Error deleting doctor: $failure")),
        (success) => emit(DoctorDeleted("Doctor deleted successfully")),
      );
    } catch (e) {
      emit(DoctorError("Error deleting doctor: $e"));
    }
  }

  Future<void> _onFetchVerifiedDoctors(
      FetchVerifiedDoctors event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final response = await doctorRepository.fetchVerifiedDoctors();
      response.fold(
        (failure) => emit(DoctorError("Error verified doctors: $failure")),
        (doctors) => emit(DoctorsLoaded(doctors)),
      );
    } catch (e) {
      emit(DoctorError("Error fetching verified doctors: $e"));
    }
  }

  Future<void> _onFetchUnverifiedDoctors(
      FetchUnverifiedDoctors event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final response = await doctorRepository.fetchUnVerifiedDoctors();
      response.fold(
        (failure) => emit(DoctorError("Error unverified doctors: $failure")),
        (doctors) => emit(DoctorsLoaded(doctors)),
      );
    } catch (e) {
      emit(DoctorError("Error fetching unverified doctors: $e"));
    }
  }
}
