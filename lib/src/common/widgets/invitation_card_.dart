// invited_doctor_card.dart
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvitedDoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  final String invitationStatus;

  const InvitedDoctorCard({
    super.key,
    required this.doctor,
    required this.invitationStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Colors.white,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundImage: NetworkImage(doctor.avatarUrl),
          ),
          SizedBox(width: 15.w),
          SizedBox(
            height: 130.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.firstname,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.specialization!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  doctor.email,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    invitationStatus,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0076BE),
                    ),
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
