import 'package:autis/core/routes/route_names.dart';
import 'package:autis/core/utils/extentions.dart';
import 'package:autis/core/utils/strings.dart';
import 'package:autis/injection_container.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../common/blocs/patient_bloc/patient_bloc.dart';
import '../../../common/blocs/patient_bloc/patient_event.dart';
import '../../../common/view/container_screen.dart';
import '../../../common/widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  initState() {
    sl<PatientBloc>().add(GetPatient());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PatientFailure) {
          return Center(
            child: Text(state.error),
          );
        }

        if (state is PatientLoaded) {
          return ContainerScreen(
            title: Strings.profile.capitalizeFirst(),
            imagePath: 'assets/images/homebg.png',
            leadingicon: Icons.arrow_back_ios_new_rounded,
            trailingIcon: Icons.person_2_rounded,
            onLeadingPress: () => sl<NavigationService>().goBack(),
            onTrailingPress: () => sl<NavigationService>()
                .pushNamed(RoutesNames.patientProfileScreen),
            children: [
              ProfileCard(
                patient: state.patient,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
