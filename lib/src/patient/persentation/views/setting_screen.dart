import 'package:autis/core/utils/strings.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../injection_container.dart';
import '../../../common/blocs/doctor_bloc/doctor_state.dart';
import '../../../common/view/container_screen.dart';
import '../../../common/widgets/doctor_selection_card.dart';
import '../../../common/blocs/doctor_bloc/doctor_bloc.dart';
import '../../../common/blocs/doctor_bloc/doctor_event.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  PatientEntity? currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    sl<DoctorBloc>().add(FetchVerifiedDoctors());
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (mounted) {
        setState(() {
          currentUser = user != null
              ? PatientEntity(
                  uid: user.uid,
                  email: user.email,
                  firstname: user.firstname,
                  lastname: user.lastname,
                  avatarUrl: user.avatarUrl,
                  dateOfBirth: user.dateOfBirth,
                  gender: user.gender,
                  createdAt: user.createdAt,
                  updatedAt: user.updatedAt,
                  phone: user.phone,
                )
              : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        return ContainerScreen(
          title: Strings.settings,
          imagePath: 'assets/images/homebg.png',
          leadingicon: Icons.arrow_back_ios_new_rounded,
          trailingIcon: Icons.person_4_rounded,
          onTrailingPress: () =>
              sl<NavigationService>().pushNamed(RoutesNames.profile),
          onLeadingPress: () => sl<NavigationService>().goBack(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: _buildContent(state),
            )
          ],
        );
      },
    );
  }

  Widget _buildContent(DoctorState state) {
    if (_isLoading || currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DoctorLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DoctorsLoaded) {
      return DoctorSelectionCard(
        doctors: state.doctors,
        user: currentUser!,
      );
    } else if (state is DoctorError) {
      return Center(child: Text(state.error));
    } else {
      return const Center(child: Text('Unexpected state'));
    }
  }
}
