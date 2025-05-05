import 'package:autis/core/utils/strings.dart';
import 'package:autis/injection_container.dart';
import 'package:autis/src/common/blocs/appointement_bloc/appointement_bloc.dart';
import 'package:autis/src/common/blocs/appointement_bloc/appointement_state.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autis/src/common/widgets/appointment_card.dart';

import '../../../common/blocs/appointement_bloc/appointement_event.dart';
import '../widgets/costom_appbar.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  final String patientId;
  const DoctorAppointmentScreen({super.key, required this.patientId});

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: Strings.appointments,
        avatarUrl: null,
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        bloc: sl<AppointmentBloc>()..add(GetDoctorAppointements()),
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentFailure) {
            return Center(child: Text(state.error));
          }

          if (state is AppointmentLoaded) {
            // Sort appointments by date (nearest first)
            final data = state.appointments
              ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
            final appointments =
                data.where((p) => p.patientId == widget.patientId).toList();

            return HomeBg(
              child: appointments.isNotEmpty
                  ? ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 110.h),
                      itemCount: appointments.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 5.h),
                      itemBuilder: (context, index) => AppointmentCard(
                        appointment: appointments[index],
                        onCancel: () {
                          sl<AppointmentBloc>().add(
                            DeletedAppointement(
                                appointments[index].appointmentId),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 64.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'You have no appointments right now!',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Check back later or refresh to see if any new appointments arrive.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
