import 'package:autis/core/utils/enums/role_enum.dart';
import 'package:autis/src/app.dart';
import 'package:autis/src/common/view/register_screen.dart';
import 'package:autis/src/common/view/splash_screen.dart';
import 'package:autis/src/doctor/persentation/views/doctor_appointment_screen.dart';
import 'package:autis/src/doctor/persentation/views/doctor_chat_screen.dart';
import 'package:autis/src/doctor/persentation/views/doctor_game_details.dart';
import 'package:autis/src/doctor/persentation/views/doctor_game_screen.dart';
import 'package:autis/src/doctor/persentation/views/doctor_profile_screen.dart';
import 'package:autis/src/doctor/persentation/views/doctor_report_screen.dart';
import 'package:autis/src/doctor/persentation/views/doctor_vedios_screen.dart';
import 'package:autis/src/patient/domain/entities/game_entity.dart';
import 'package:autis/src/patient/domain/entities/level_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:autis/src/patient/persentation/views/appointments_screen.dart';
import 'package:autis/src/patient/persentation/views/conversation_screen.dart';
import 'package:autis/src/patient/persentation/views/level_questions_screen.dart';
import 'package:autis/src/patient/persentation/views/profile_screen.dart';
import 'package:autis/src/patient/persentation/views/reports_screen.dart';
import 'package:autis/src/patient/persentation/views/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../src/common/view/login_screen.dart';
import '../../src/patient/persentation/views/game_level_screen.dart';
import '../../src/patient/persentation/views/patient_vedios_screen.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter router = _buildRouter();

  static GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: RoutesNames.splash,
      errorPageBuilder: (context, state) => MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text(state.error.toString()),
          ),
        ),
      ),
      routes: [
        // Splash Screen
        GoRoute(
          name: RoutesNames.splash,
          path: RoutesNames.splash,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const SplashScreen(),
          ),
        ),
        // Login Screen
        GoRoute(
          name: RoutesNames.login,
          path: RoutesNames.login,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const LoginScreen(),
          ),
        ),
        // Register Screen
        GoRoute(
          name: RoutesNames.register,
          path: RoutesNames.register,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const RegisterScreen(),
          ),
        ),
        // Doctor Home Screen
        GoRoute(
          name: RoutesNames.home,
          path: RoutesNames.home,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            App(role: state.extra as Role),
          ),
        ),
        // Game Screen
        GoRoute(
          name: RoutesNames.game,
          path: RoutesNames.game,
          pageBuilder: (context, state) {
            final game = state.extra as GameEntity;
            return _fadeTransition(
              state,
              GameLevelScreen(
                game: game,
              ),
            );
          },
        ),
        // Settings Screen
        GoRoute(
          name: RoutesNames.settings,
          path: RoutesNames.settings,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const Settings(),
          ),
        ),
        // Profile Screen
        GoRoute(
          name: RoutesNames.profile,
          path: RoutesNames.profile,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const ProfileScreen(),
          ),
        ),
        // Report Screen
        GoRoute(
            name: RoutesNames.reports,
            path: RoutesNames.reports,
            pageBuilder: (context, state) {
              // final patient = state.extra as PatientEntity;

              return _fadeTransition(
                state,
                const ReportsScreen(),
              );
            }),
        // Appointements Screen
        GoRoute(
          name: RoutesNames.appointements,
          path: RoutesNames.appointements,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const AppointmentsScreen(),
          ),
        ),
        // Conversation Screen
        GoRoute(
          name: RoutesNames.conversation,
          path: RoutesNames.conversation,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const ConversationScreen(),
          ),
        ),
        // Question Screen
        GoRoute(
          name: RoutesNames.questions,
          path: RoutesNames.questions,
          pageBuilder: (context, state) {
            final level = state.extra as LevelEntity;

            return _fadeTransition(
              state,
              LevelQuestionsScreen(
                level: level,
              ),
            );
          },
        ),
        // Doctor Conversations
        GoRoute(
            name: RoutesNames.doctorConversation,
            path: RoutesNames.doctorConversation,
            pageBuilder: (context, state) {
              final data = state.extra as PatientEntity;

              return _fadeTransition(
                state,
                DoctorChatScreen(patient: data),
              );
            }),
        GoRoute(
            name: RoutesNames.doctorAppointments,
            path: RoutesNames.doctorAppointments,
            pageBuilder: (context, state) {
              final patientId = state.extra as String;
              return _fadeTransition(
                state,
                DoctorAppointmentScreen(
                  patientId: patientId,
                ),
              );
            }),
        GoRoute(
          name: RoutesNames.doctorGames,
          path: RoutesNames.doctorGames,
          pageBuilder: (context, state) {
            final patient = state.extra as PatientEntity;

            return _fadeTransition(
              state,
              DoctorGameScreen(
                patient: patient,
              ),
            );
          },
        ),
        GoRoute(
          name: RoutesNames.doctorReports,
          path: RoutesNames.doctorReports,
          pageBuilder: (context, state) {
            final patient = state.extra as PatientEntity;
            return _fadeTransition(
              state,
              DoctorReportScreen(
                patient: patient,
              ),
            );
          },
        ),
        GoRoute(
          name: RoutesNames.doctorProfile,
          path: RoutesNames.doctorProfile,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const DoctorProfileScreen(),
          ),
        ),
        GoRoute(
          name: RoutesNames.doctorGameDetails,
          path: RoutesNames.doctorGameDetails,
          pageBuilder: (context, state) {
            final game = state.extra as GameEntity;

            return _fadeTransition(
              state,
              DoctorGameDetails(
                game: game,
              ),
            );
          },
        ),
        GoRoute(
          name: RoutesNames.doctorVediosScreen,
          path: RoutesNames.doctorVediosScreen,
          pageBuilder: (context, state) {
            final patientId = state.extra as String;

            return _fadeTransition(
              state,
              DoctorVideosScreen(
                patientId: patientId,
              ),
            );
          },
        ),
        GoRoute(
          name: RoutesNames.patientvediosscreen,
          path: RoutesNames.patientvediosscreen,
          pageBuilder: (context, state) {
            return _fadeTransition(
              state,
              const PatientVideosScreen(),
            );
          },
        ),
      ],
    );
  }

  static CustomTransitionPage _fadeTransition(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
