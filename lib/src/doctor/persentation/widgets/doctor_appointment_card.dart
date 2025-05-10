import 'package:autis/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../common/entitys/appointement_entity.dart';

class DoctorAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onReject;
  final VoidCallback onAccept;
  // final VoidCallback onReschedule;
  final Color primaryColor = const Color(0xFF0076BE);
  final Color accentColor = const Color(0xFF00F1F8);
  final Color pastAppointmentColor = Colors.grey[300]!;

  DoctorAppointmentCard({
    super.key,
    required this.appointment,
    required this.onReject,
    required this.onAccept,
    // required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;
    final patient = appointment.patient;
    final status = appointment.status;
    final formattedDate =
        DateFormat('EEE, MMM d, y').format(appointment.appointmentDate);
    final formattedTime =
        DateFormat('h:mm a').format(appointment.appointmentDate);
    final isUpcoming = appointment.appointmentDate.isAfter(DateTime.now());
    final cardColor = isUpcoming ? Colors.white : pastAppointmentColor;
    final contentColor = isUpcoming ? Colors.black87 : Colors.grey[700];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: status == 'accepted'
                    ? primaryColor.withOpacity(0.2)
                    : Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                status.capitalizeFirst(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: status == 'accepted' ? primaryColor : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Doctor Info Row
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: NetworkImage(doctor.avatarUrl),
                  backgroundColor: status == 'accepted'
                      ? primaryColor.withOpacity(0.2)
                      : Colors.white.withOpacity(0.4),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${doctor.firstname} ${doctor.lastname}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doctor.specialization ?? 'General Practitioner',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: contentColor?.withOpacity(0.7),
                        ),
                      ),
                      if (doctor.isVerified) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.verified,
                                size: 16.w,
                                color: isUpcoming
                                    ? Colors.blue
                                    : Colors.grey[600]),
                            SizedBox(width: 4.w),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color:
                                    isUpcoming ? Colors.blue : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Appointment Details
            _buildDetailRow(
              icon: Icons.calendar_today,
              text: formattedDate,
              color: contentColor!,
              iconColor: isUpcoming ? primaryColor : Colors.grey[600]!,
            ),
            SizedBox(height: 8.h),
            _buildDetailRow(
              icon: Icons.access_time,
              text: formattedTime,
              color: contentColor,
              iconColor: isUpcoming ? primaryColor : Colors.grey[600]!,
            ),
            if (appointment.location != null) ...[
              SizedBox(height: 8.h),
              _buildDetailRow(
                icon: Icons.location_on,
                text: appointment.location!,
                color: contentColor,
                iconColor: isUpcoming ? primaryColor : Colors.grey[600]!,
              ),
            ],
            SizedBox(height: 16.h),

            // Patient Info
            if (patient.age != null) ...[
              Text(
                'Patient: ${patient.firstname} ${patient.lastname} (${patient.age} years)',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: contentColor,
                ),
              ),
              SizedBox(height: 4.h),
            ],
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onReject,
                    child: _buildActionButton(
                      text: 'Reject',
                      icon: Icons.cancel,
                      color: Colors.red,
                      onPressed: onReject,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onAccept,
                    child: _buildActionButton(
                      text: 'Accepet',
                      icon: Icons.done,
                      color: primaryColor,
                      onPressed: onAccept,
                    ),
                  ),
                )
              ],
            ),
            // GestureDetector(
            //   onTap: onReschedule,
            //   child: _buildActionButton(
            //     text: 'Reschedule',
            //     icon: Icons.schedule,
            //     color: Colors.grey,
            //     onPressed: onReschedule,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    required Color color,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.w,
          color: iconColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 18.w),
        label: Text(
          text,
          style: TextStyle(fontSize: 14.sp),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
