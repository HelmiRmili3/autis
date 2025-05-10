import 'package:autis/core/routes/route_names.dart';
import 'package:autis/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../injection_container.dart';
import '../../../common/blocs/doctor_bloc/doctor_bloc.dart';
import '../../../common/blocs/doctor_bloc/doctor_event.dart';
import '../../../common/blocs/doctor_bloc/doctor_state.dart';
import '../../../common/entitys/user_entity.dart';

class DoctorCheckAuthorizedScreen extends StatefulWidget {
  const DoctorCheckAuthorizedScreen({super.key});

  @override
  State<DoctorCheckAuthorizedScreen> createState() =>
      _DoctorCheckAuthorizedScreenState();
}

class _DoctorCheckAuthorizedScreenState
    extends State<DoctorCheckAuthorizedScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      final UserEntity? user = await sl<UserProfileStorage>().getUserProfile();
      if (user != null) {
        sl<DoctorBloc>().add(FetchDoctor(doctorId: user.uid));
      }
    } catch (e) {
      // Handle error appropriately
      debugPrint('Error initializing user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DoctorBloc, DoctorState>(
        listener: (context, state) {
          if (state is DoctorLoaded) {
            if (state.doctor.isVerified) {
              sl<NavigationService>()
                  .replaceNamed(RoutesNames.doctorHomeScreen);
            } else {
              sl<NavigationService>()
                  .replaceNamed(RoutesNames.doctorNotAuthorizedScreen);
            }
          }
        },
        builder: (context, state) {
          if (state is DoctorLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DoctorError) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
