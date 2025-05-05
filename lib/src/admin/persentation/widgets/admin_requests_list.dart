import 'package:autis/src/common/blocs/doctor_bloc/doctor_event.dart';
import 'package:autis/src/common/blocs/doctor_bloc/doctor_state.dart';
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import '../../../common/blocs/doctor_bloc/doctor_bloc.dart';

class AdminRequestsList extends StatefulWidget {
  const AdminRequestsList({super.key});

  @override
  State<AdminRequestsList> createState() => _AdminRequestsListState();
}

class _AdminRequestsListState extends State<AdminRequestsList> {
  @override
  void initState() {
    super.initState();
    sl<DoctorBloc>().add(FetchUnverifiedDoctors());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is DoctorLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DoctorsLoaded) {
          return _buildDoctorsList(state.doctors);
        }
        return const Center(child: Text('No doctors found'));
      },
    );
  }

  Widget _buildDoctorsList(List<DoctorEntity> doctors) {
    if (doctors.isEmpty) {
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
              'No Doctors Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'There are currently no doctors to display.\nNew requests will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                sl<DoctorBloc>().add(FetchUnverifiedDoctors());
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

    return RefreshIndicator(
      onRefresh: () async {
        // sl<DoctorBloc>().add(FetchVerifiedDoctors());
        sl<DoctorBloc>().add(FetchUnverifiedDoctors());
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 120.h, horizontal: 16.w),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return _doctorCard(doctor, context);
        },
      ),
    );
  }

  Widget _doctorCard(DoctorEntity doctor, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: doctor.avatarUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            doctor.avatarUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          '${doctor.firstname[0]}${doctor.lastname[0]}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${doctor.firstname} ${doctor.lastname}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialization ?? 'General Practitioner',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    doctor.isVerified ? 'Verified' : 'Pending',
                    style: TextStyle(
                      color: doctor.isVerified ? Colors.green : Colors.orange,
                    ),
                  ),
                  backgroundColor: doctor.isVerified
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...[
              _doctorInfoRow(Icons.email, doctor.email),
              const SizedBox(height: 8),
            ],
            if (doctor.phone != null)
              _doctorInfoRow(Icons.phone, doctor.phone!),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!doctor.isVerified)
                  TextButton(
                    onPressed: () => _verifyDoctor(context, doctor),
                    child: const Text('Verify'),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, doctor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _doctorInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _verifyDoctor(BuildContext context, DoctorEntity doctor) {
    // Implement verification logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Doctor'),
        content: Text(
          'Verify Dr. ${doctor.firstname} ${doctor.lastname}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              sl<DoctorBloc>().add(
                VerifyDoctor(
                  id: doctor.uid,
                  isVerified: true,
                ),
              );
              Navigator.pop(context);
              // Add your verification logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Doctor verified successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, DoctorEntity doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Delete Dr. ${doctor.firstname} ${doctor.lastname}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              sl<DoctorBloc>().add(DeleteDoctor(doctorId: doctor.uid));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
