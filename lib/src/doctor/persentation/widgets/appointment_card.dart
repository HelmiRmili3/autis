import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/entitys/appointement_entity.dart'; // For date formatting

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar Section (Left)
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(appointment.patient
                  .avatarUrl), // Assuming DoctorEntity has profilePictureUrl
              child: appointment.patient.avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),

            // Doctor Info (Middle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. ${appointment.doctor.firstname}', // Assuming DoctorEntity has fullName
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   appointment.doctor
                  //       .specialization, // Assuming DoctorEntity has specialization
                  //   style: TextStyle(
                  //     color: Colors.grey[600],
                  //     fontSize: 14,
                  //   ),
                  // ),
                  // const SizedBox(height: 4),
                  if (appointment.location != null)
                    Text(
                      appointment.location!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // Date & Time (Right)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('MMM d').format(appointment.appointmentDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(appointment.appointmentDate),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
