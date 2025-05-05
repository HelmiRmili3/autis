import 'package:autis/core/utils/strings.dart';
import 'package:autis/injection_container.dart';
import 'package:autis/src/common/blocs/invite_bloc/invite_bloc.dart';
import 'package:autis/src/common/blocs/invite_bloc/invite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../common/blocs/appointement_bloc/appointement_bloc.dart';
import '../../../common/blocs/appointement_bloc/appointement_event.dart';
import '../../../common/blocs/appointement_bloc/appointement_state.dart';
import '../../../common/blocs/invite_bloc/invite_event.dart';
import '../../../common/view/container_screen.dart';
import '../../../common/widgets/appointment_card.dart';
import '../../domain/entities/patient_entity.dart';
import '../widgets/popup_form.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late PatientEntity? currentPatient;

  @override
  void initState() {
    super.initState();
    _loadPatientFromStorage();
  }

  Future<void> _loadPatientFromStorage() async {
    final user = await sl<UserProfileStorage>().getUserProfile();

    if (user != null) {
      setState(() {
        currentPatient = PatientEntity(
          uid: user.uid,
          email: user.email,
          firstname: user.firstname,
          lastname: user.lastname,
          avatarUrl: user.avatarUrl,
          gender: user.gender,
          phone: user.phone ?? '',
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      bloc: sl<AppointmentBloc>()..add(GetPatientAppointements()),
      builder: (context, state) {
        if (state is AppointmentFailure) {
          return Center(child: Text(state.error));
        }
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AppointmentLoaded) {
          return ContainerScreen(
            title: Strings.appointments,
            imagePath: 'assets/images/homebg.png',
            leadingicon: Icons.arrow_back_ios_new_rounded,
            onLeadingPress: () => sl<NavigationService>().goBack(),
            floatingActionButton: ElevatedButton.icon(
              onPressed: () {
                _showCreateAppointmentPopup(context);
              },
              icon: const Icon(Icons.add),
              label: const Text("Add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
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
              ),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 20.h),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor: Colors.white,
              //       backgroundColor: const Color(0xFF0076BE),
              //       padding: EdgeInsets.symmetric(vertical: 15.h),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30.r),
              //       ),
              //     ),
              //     onPressed: () {
              //       _showCreateAppointmentPopup(context);
              //     },
              //     child: Text(
              //       'CREATE APPOINTMENT',
              //       style: TextStyle(
              //         fontSize: 16.sp,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showCreateAppointmentPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Create Appointment",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return BlocBuilder<InviteBloc, InviteState>(
          bloc: sl<InviteBloc>()
            ..add(CheckInviteStatus(patientId: currentPatient!.uid)),
          builder: (context, state) {
            if (state is InviteAccepted) {
              return AppointmentForm(
                patient: currentPatient!,
                initialDoctor: state.invite.doctor,
                onCancel: () => Navigator.pop(context),
              );
            }
            if (state is InviteRejected) {
              return const Center(
                child: Text(
                    "You can not add appointment you have to be accepted by a doctor"),
              );
            }
            if (state is InvitePending) {
              return const Center(
                child: Text(
                    "You can not add appointment you have to be accepted by a doctor"),
              );
            }

            if (state is InviteLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is InviteFailure) {
              return Center(child: Text(state.error));
            }
            return const SizedBox.shrink();
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
