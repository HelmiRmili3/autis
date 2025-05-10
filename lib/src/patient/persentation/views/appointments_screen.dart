import 'package:autis/src/common/blocs/appointement_bloc/appointement_state.dart';
import 'package:autis/src/common/entitys/user_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';
import '../../../common/blocs/appointement_bloc/appointement_bloc.dart';
import '../../../common/blocs/appointement_bloc/appointement_event.dart';
import '../../../common/blocs/invite_bloc/invite_bloc.dart';
import '../../../common/blocs/invite_bloc/invite_event.dart';
import '../../../common/blocs/invite_bloc/invite_state.dart';
import '../../../common/view/container_screen.dart';
import '../../../common/widgets/appointment_card.dart';
import '../widgets/popup_form.dart';

class AppointmentsScreen extends StatefulWidget {
  final UserEntity user;
  const AppointmentsScreen({
    super.key,
    required this.user,
  });

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  void initState() {
    sl<AppointmentBloc>().add(GetPatientAppointements());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPatient = PatientEntity.fromJson(widget.user.toMap());
    return ContainerScreen(
      title: Strings.appointments,
      imagePath: 'assets/images/homebg.png',
      leadingicon: Icons.arrow_back_ios_new_rounded,
      onLeadingPress: () => sl<NavigationService>().goBack(),
      floatingActionButton: _buildFloatingActionButton(context, currentPatient),
      children: [
        BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AppointmentFailure) {
              // debugPrint("==============> ${state.toString()}");

              return Center(child: Text(state.error));
            }
            if (state is AppointmentLoading) {
              // debugPrint("==============> ${state.toString()}");

              return const Center(child: CircularProgressIndicator());
            }
            if (state is AppointmentLoaded) {
              // debugPrint("==============> ${state.toString()}");

              return SizedBox(
                height: 650.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.appointments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: AppointmentCard(
                        appointment: state.appointments[index],
                        onCancel: () {
                          sl<AppointmentBloc>().add(
                            DeletedAppointement(
                              state.appointments[index].appointmentId,
                            ),
                          );
                        },
                        onReschedule: () {},
                      ),
                    );
                  },
                ),
              );
            }
            // debugPrint("==============> ${state.toString()}");

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, PatientEntity currentPatient) {
    return ElevatedButton.icon(
      onPressed: () => _showCreateAppointmentPopup(context, currentPatient),
      icon: const Icon(Icons.add),
      label: const Text("Demande"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showCreateAppointmentPopup(BuildContext context, currentPatient) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Create Appointment",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        sl<InviteBloc>().add(CheckInviteStatus(patientId: currentPatient!.uid));

        return BlocBuilder<InviteBloc, InviteState>(
          builder: (context, state) {
            if (state is InviteAccepted) {
              return AppointmentForm(
                patient: currentPatient!,
                initialDoctor: state.invite.doctor,
                onCancel: () => Navigator.pop(context),
                onSubmit: () {
                  sl<AppointmentBloc>().add(GetPatientAppointements());
                  Navigator.pop(context);
                },
              );
            }
            if (state is InviteRejected || state is InvitePending) {
              return AlertDialog(
                title: const Text("Invitation Required"),
                content: const Text(
                    "You need to be accepted by a doctor before creating appointments"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            }
            if (state is InviteLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is InviteFailure) {
              return AlertDialog(
                title: const Text("No  Invitation Sent"),
                content: const Text(
                    "You need to to send Invitation  a doctor before creating appointments"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
        );
      },
    );
  }
}
