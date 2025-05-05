// doctor_list_widget.dart
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorListWidget extends StatelessWidget {
  final List<DoctorEntity> doctors;
  final int? selectedDoctorIndex;
  final bool hasInvitation;
  final Function(int) onDoctorSelected;

  const DoctorListWidget({
    super.key,
    required this.doctors,
    required this.selectedDoctorIndex,
    required this.hasInvitation,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasInvitation ? 'Invitation Status' : '',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: doctors.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.3),
                height: 20.h,
              ),
              itemBuilder: (context, index) => _buildDoctorTile(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorTile(int index) {
    final doctor = doctors[index];
    return GestureDetector(
      onTap: () {
        if (!hasInvitation) {
          onDoctorSelected(index);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: selectedDoctorIndex == index
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: selectedDoctorIndex == index
                ? Colors.white
                : Colors.transparent,
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
            Expanded(
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
                ],
              ),
            ),
            if (!hasInvitation)
              Radio<int>(
                value: index,
                groupValue: selectedDoctorIndex,
                onChanged: (value) {
                  if (!hasInvitation && value != null) {
                    onDoctorSelected(value);
                  }
                },
                activeColor: Colors.white,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (states) => Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
