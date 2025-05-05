import 'package:autis/src/common/blocs/chat_bloc/chat_bloc.dart';
import 'package:autis/src/common/blocs/game_bloc/game_bloc.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_bloc.dart';
import 'package:autis/src/common/repository/chat_repository.dart';
import 'package:autis/src/common/repository/game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '/core/services/navigation_service.dart';
import '/core/utils/connection.dart';
import '/src/common/blocs/appointement_bloc/appointement_bloc.dart';
import '/src/common/blocs/doctor_bloc/doctor_bloc.dart';
import '/src/common/blocs/invite_bloc/invite_bloc.dart';
import '/src/common/blocs/report_bloc/report_bloc.dart';
import '/src/common/data/appointement_remote_data_sources.dart';
import '/src/common/data/auth_remote_data_sources.dart';
import '/src/common/data/doctor_remote_data_sources.dart';
import '/src/common/data/invite_remote_data_sources.dart';
import '/src/common/data/patient_remote_data_sources.dart';
import '/src/common/data/report_remote_data_sources.dart';
import '/src/common/repository/appointement_repository.dart';
import '/src/common/repository/appointement_repository_impl.dart';
import '/src/common/repository/doctor_repository.dart';
import '/src/common/repository/invite_repository.dart';
import '/src/common/repository/invite_repository_impl.dart';
import '/src/common/repository/patient_repository.dart';
import '/src/common/repository/report_repository.dart';
import '/src/common/usecases/auth_usecases/login_usecase.dart';
import '/src/common/usecases/auth_usecases/logout_usecase.dart';

import 'core/errors/error_mapper.dart';
import 'core/errors/firebase_exception_handler.dart';
import 'core/routes/app_routes.dart';
import 'core/services/cloudinary_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/utils/file_picker.dart';
import 'src/common/blocs/auth_bloc/auth_bloc.dart';
import 'src/common/blocs/auth_bloc/auth_event.dart';
import 'src/common/data/chat_remote_data_source.dart';
import 'src/common/data/game_local_data_source.dart';
import 'src/common/data/game_remote_data_source.dart';
import 'src/common/repository/auth_repository.dart';
import 'src/common/repository/auth_repository_impl.dart';
import 'src/common/repository/chat_repository_impl.dart';
import 'src/common/repository/doctor_repository_impl.dart';
import 'src/common/repository/game_repository_impl.dart';
import 'src/common/repository/patient_repository_impl.dart';
import 'src/common/repository/report_repository_impl.dart';
import 'src/common/usecases/auth_usecases/register_usecase.dart';

final sl = GetIt.instance;

class DependencyInjection {
  static final DependencyInjection _instance = DependencyInjection._internal();

  factory DependencyInjection() {
    return _instance;
  }

  DependencyInjection._internal();

  Future<void> init() async {
    // Firebase services initialization
    sl.registerSingleton(FirebaseFirestore.instance);
    sl.registerSingleton(FirebaseAuth.instance);
    sl.registerSingleton(FirebaseDatabase.instance);
    sl.registerSingleton<CloudinaryRestService>(CloudinaryRestService());

    // Router
    sl.registerSingleton<GoRouter>(AppRouter.router);
    // Flutter secure Storage
    sl.registerSingleton<FlutterSecureStorage>(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(),
      ),
    );
    sl.registerSingleton(UserProfileStorage(sl()));
    final storedUser = await sl<UserProfileStorage>().getUserProfile();

    if (storedUser != null) {
      debugPrint(
          "Current user is id ${storedUser.uid} : email ${storedUser.email}");
    } else {
      debugPrint("No user is currently stored.");
    } // Data sources
    sl.registerSingleton<GameLocalDataSource>(GameLocalDataSourceImpl());

    sl.registerSingleton<GameRemoteDataSource>(
        GameRemoteDataSourceImpl(sl(), sl()));
    sl.registerSingleton<AuthRemoteDataSource>(
        AuthRemoteDataSourcesImpl(sl(), sl()));
    sl.registerSingleton<InviteRemoteDataSources>(
        InviteRemoteDataSourcesImpl(sl(), sl()));
    sl.registerSingleton<AppointmentRemoteDataSource>(
        AppointmentRemoteDataSourceImpl(sl(), sl()));
    sl.registerSingleton<DoctorRemoteDataSource>(
        DoctorRemoteDataSourcesImpl(sl(), sl()));
    sl.registerSingleton<ReportRemoteDataSource>(
        ReportRemoteDataSourceImpl(sl(), sl()));
    sl.registerSingleton<PatientRemoteDataSource>(
        PatientRemoteDataSourceImpl(sl(), sl()));
    sl.registerSingleton<ChatRemoteDataSource>(ChatRemoteDataSourceImpl(
      sl(),
      sl(),
      sl(),
      sl(),
    ));

    // Helpers
    sl.registerSingleton(FirebaseExceptionHandler());
    sl.registerSingleton(ErrorMapper());

    // Repositories
    sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
    sl.registerSingleton<InviteRepository>(InviteRepositoryImpl(sl()));
    sl.registerSingleton<AppointmentRepository>(AppointmentRepositoryImpl(
      sl(),
    ));
    sl.registerSingleton<DoctorRepository>(DoctorRepositoryImpl(sl()));
    sl.registerSingleton<ReportRepository>(ReportRepositoryImpl(sl()));
    sl.registerSingleton<PatientRepository>(PatientRepositoryImpl(sl()));
    sl.registerSingleton<GameRepository>(GameRepositoryImpl(sl()));
    sl.registerSingleton<ChatRepository>(ChatRepositoryImpl(sl()));

    // Use cases
    sl.registerSingleton<LoginUsecase>(LoginUsecase(sl()));
    sl.registerSingleton<RegisterUsecase>(RegisterUsecase(sl()));
    sl.registerSingleton<LogoutUsecase>(LogoutUsecase(sl()));

    // Blocs
    sl.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        sl(),
        sl(),
        sl(),
      )..add(AuthStarted()),
    );
    sl.registerLazySingleton<InviteBloc>(() => InviteBloc(
          sl(),
          sl(),
        ));
    sl.registerFactory<AppointmentBloc>(
      () => AppointmentBloc(
        sl(),
      ),
    );
    sl.registerLazySingleton<DoctorBloc>(() => DoctorBloc(sl()));
    sl.registerLazySingleton<ReportBloc>(() => ReportBloc(sl()));
    sl.registerLazySingleton<PatientBloc>(
      () => PatientBloc(
        sl(),
        sl(),
      ),
    );
    sl.registerLazySingleton<GameBloc>(
      () => GameBloc(
        sl(),
      ),
    );
    sl.registerLazySingleton<ChatBloc>(
      () => ChatBloc(
        sl(),
        sl(),
      ),
    );

    sl.registerSingleton(NotificationService());
    sl.registerSingleton(FilePicker());
    sl.registerSingleton(NavigationService(sl()));
    sl.registerSingleton<Connection>(Connection());

    // Other dependencies
  }
}
