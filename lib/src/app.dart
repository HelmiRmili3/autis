import 'package:flutter/material.dart';
import '../core/utils/enums/role_enum.dart';
import 'admin/persentation/views/admin_home_screen.dart';
import 'common/view/user_not_fount_screen.dart';
import 'doctor/persentation/views/doctor_check_authorized_screen.dart';
import 'doctor/persentation/views/doctor_home_screen.dart';
import 'patient/persentation/views/patient_home_screen.dart';

class App extends StatefulWidget {
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
  Widget build(BuildContext context) {
    // Route based on role
    switch (widget.role) {
      case Role.doctor:
        return const DoctorCheckAuthorizedScreen();
      case Role.patient:
        return const PatientHomeScreen();
      case Role.admin:
        return const AdminHomeScreen();
      default:
        return const UserNotFoundScreen();
    }
  }
}
