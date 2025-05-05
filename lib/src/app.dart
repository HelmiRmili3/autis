import 'package:autis/src/common/blocs/doctor_bloc/doctor_bloc.dart';
import 'package:autis/src/common/blocs/doctor_bloc/doctor_state.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/secure_storage_service.dart';
import '../core/utils/enums/role_enum.dart';
import '../injection_container.dart';
import 'admin/persentation/views/admin_home_screen.dart';
import 'common/blocs/doctor_bloc/doctor_event.dart';
import 'common/view/user_not_fount_screen.dart';
import 'doctor/persentation/views/doctor_home_screen.dart';
import 'patient/persentation/views/patient_home_screen.dart';

class App extends StatefulWidget {
  /// The main entry point of the application.
  final Role role;
  const App({
    super.key,
    required this.role,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      final UserEntity? user = await sl<UserProfileStorage>().getUserProfile();
      if (user != null && widget.role == Role.doctor) {
        sl<DoctorBloc>().add(FetchDoctor(doctorId: user.uid));
      }
    } catch (e) {
      // Handle error appropriately
      debugPrint('Error initializing user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.role) {
      case Role.doctor:
        return BlocConsumer<DoctorBloc, DoctorState>(
          listener: (context, state) {
            // You can add side effects here if needed
          },
          builder: (context, state) {
            if (state is DoctorLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is DoctorError) {
              return Scaffold(
                body: Center(child: Text('Error: ${state.error}')),
              );
            }
            if (state is DoctorLoaded && state.doctor.isVerified) {
              return const DoctorHomeScreen();
            }
            if (state is DoctorLoaded && !state.doctor.isVerified) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 80,
                          color: Colors.orange.withOpacity(0.7),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Account Pending Verification",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Your doctor account is currently being reviewed by our admin team. "
                          "This process typically takes 1-2 business days.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("Check Verification Status"),
                          onPressed: () {
                            // Add logic to check verification status
                            sl<DoctorBloc>()
                                .add(FetchDoctor(doctorId: state.doctor.uid));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // TextButton(
                        //   child: const Text("Contact Support"),
                        //   onPressed: () {
                        //     // Add logic to contact support
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        );
      case Role.patient:
        return const PatientHomeScreen();
      case Role.admin:
        return const AdminHomeScreen();
      default:
        return const UserNotFoundScreen();
    }
  }
}
