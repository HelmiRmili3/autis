import 'package:autis/core/routes/route_names.dart';
import 'package:autis/core/services/navigation_service.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';
import 'detail_row.dart';

class ProfileCard extends StatelessWidget {
  final PatientEntity patient;
  const ProfileCard({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4, // 40%
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 170.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(patient.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 6, // 60%
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patient.firstname} ${patient.lastname}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          DetailRow(icon: Icons.email, text: patient.email),
                          const SizedBox(height: 8),
                          DetailRow(icon: Icons.phone, text: patient.phone!),
                          const SizedBox(height: 8),
                          // DetailRow(
                          //     icon: Icons.location_on, text: patient.location!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.accessibility,
                    color: Colors.white,
                  ),
                  onPressed: () => sl<NavigationService>().pushNamed(
                    extra: patient.uid,
                    RoutesNames.doctorVediosScreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.chat_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => sl<NavigationService>().pushNamed(
                    RoutesNames.doctorConversation,
                    extra: patient,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.sports_football,
                    color: Colors.white,
                  ),
                  onPressed: () => sl<NavigationService>().pushNamed(
                    extra: patient,
                    RoutesNames.doctorGames,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.receipt,
                    color: Colors.white,
                  ),
                  onPressed: () => sl<NavigationService>().pushNamed(
                    extra: patient,
                    RoutesNames.doctorReports,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.pin_drop,
                    color: Colors.white,
                  ),
                  onPressed: () => sl<NavigationService>().pushNamed(
                    extra: patient.uid,
                    RoutesNames.doctorAppointments,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
