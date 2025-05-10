import 'package:autis/core/services/secure_storage_service.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_event.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_state.dart';
import 'package:autis/src/common/repository/patient_repository.dart';

import 'package:bloc/bloc.dart';

import '../../entitys/video.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository _patientRepository;
  final UserProfileStorage user;
  PatientBloc(
    this._patientRepository,
    this.user,
  ) : super(PatientInitial()) {
    on<GetPatients>(_onGetPatients);
    on<GetPatientsByDoctor>(_onGetPatientsByDoctor);
    on<DeletePatient>(_onDeletePatient);
    on<UpdatePatient>(_onUpdatePatient);
    on<GetPatient>(_onGetPatient);
    on<UploadVedio>(_onUploadVedio);
    on<DeleteVedio>(_onDeleteVedio);
    on<GetAllVedios>(_onGetAllVedios);
  }

  void _onGetPatient(GetPatient event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final response = await _patientRepository.getPatient();
      response.fold(
        (failure) {
          emit(PatientFailure(failure.message));
        },
        (patient) {
          emit(PatientLoaded(patient));
        },
      );
    } catch (e) {
      emit(PatientFailure(e.toString()));
    }
  }

  void _onGetPatients(GetPatients event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final response = await _patientRepository.getPatients();
      response.fold(
        (failure) {
          emit(PatientFailure(failure.message));
        },
        (patients) {
          emit(PatientsLoaded(patients));
        },
      );
    } catch (e) {
      emit(PatientFailure(e.toString()));
    }
  }

  void _onGetPatientsByDoctor(
      GetPatientsByDoctor event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final userData = await user.getUserProfile();

      final response =
          await _patientRepository.getPatientsByDoctor(userData!.uid);
      response.fold(
        (failure) {
          emit(PatientFailure(failure.message));
        },
        (patients) {
          emit(PatientsLoaded(patients));
        },
      );
    } catch (e) {
      emit(PatientFailure(e.toString()));
    }
  }

  void _onDeletePatient(DeletePatient event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final response = await _patientRepository.delete(event.patientId);
      response.fold(
        (failure) {
          emit(PatientFailure(failure.message));
        },
        (patients) {
          emit(PatientsLoaded(patients));
        },
      );
    } catch (e) {
      emit(PatientFailure(e.toString()));
    }
  }

  void _onUpdatePatient(UpdatePatient event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final response = await _patientRepository.update(event.patient);
      response.fold(
        (failure) {
          emit(PatientFailure(failure.message));
        },
        (_) {
          emit(PatientsLoaded([])); // Update with actual data if needed
        },
      );
    } catch (e) {
      emit(PatientFailure(e.toString()));
    }
  }

  // ADD THE REST OF THE FUNCTIONALITY IN HERE
  void _onUploadVedio(UploadVedio event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final Video vedio = Video.create(
        patientId: event.patientId,
        title: event.title,
        thumbnail: event.thumbnail,
        videoUrl: event.videoUrl,
        duration: event.duration,
      );
      final response = await _patientRepository.addVediosByPatient(vedio);
      response.fold(
        (failure) {
          emit(VedioFailure(failure.message));
        },
        (vedios) {
          emit(VediosLoaded(vedios));
        },
      );
    } catch (e) {
      emit(VedioFailure(e.toString()));
    }
  }

  void _onDeleteVedio(DeleteVedio event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final response = await _patientRepository.deleteVediosByPatient(event.id);
      response.fold(
        (failure) {
          emit(VedioFailure(failure.message));
        },
        (vedios) {
          emit(VediosLoaded(vedios));
        },
      );
    } catch (e) {
      emit(VedioFailure(e.toString()));
    }
  }

  void _onGetAllVedios(GetAllVedios event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final response =
          await _patientRepository.getVediosByPatient(event.patientId);
      response.fold(
        (failure) {
          emit(VedioFailure(failure.message));
        },
        (vedios) {
          emit(VediosLoaded(vedios));
        },
      );
    } catch (e) {
      emit(VedioFailure(e.toString()));
    }
  }
}
