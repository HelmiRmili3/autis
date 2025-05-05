import 'package:autis/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/blocs/patient_bloc/patient_bloc.dart';
import '../../../common/blocs/patient_bloc/patient_event.dart';
import '../../../common/blocs/patient_bloc/patient_state.dart';
import 'patient_card.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  @override
  void initState() {
    super.initState();
    sl<PatientBloc>().add(GetPatientsByDoctor());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PatientFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is PatientsLoaded) {
          final patients = state.patients;

          if (patients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No patients Found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'There are currently no patients to display.\nNew patients will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      sl<PatientBloc>().add(GetPatientsByDoctor());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 105.h, bottom: 80.h),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return ProfileCard(patient: patients[index]);
              },
            ),
          );
        } else {
          return const SizedBox(); // fallback for initial state
        }
      },
    );
  }
}
