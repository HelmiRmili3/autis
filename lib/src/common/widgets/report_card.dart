import 'package:autis/src/common/entitys/report_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback? onViewDetails;
  final VoidCallback? onShare;

  final Color primaryColor = const Color(0xFF0076BE);
  final Color accentColor = const Color(0xFF00F1F8);

  const ReportCard({
    super.key,
    required this.report,
    this.onViewDetails,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, y').format(report.createdAt);
    final formattedTime = DateFormat('h:mm a').format(report.createdAt);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Doctor Info
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: NetworkImage(report.doctor.avatarUrl),
                  backgroundColor: primaryColor.withOpacity(0.2),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${report.doctor.firstname} ${report.doctor.lastname}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        report.doctor.specialization ?? 'General Practitioner',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Appointment Details
            _buildDetailRow(icon: Icons.calendar_today, text: formattedDate),
            SizedBox(height: 8.h),
            _buildDetailRow(icon: Icons.access_time, text: formattedTime),

            SizedBox(height: 16.h),

            // Report Summary (Placeholder - customize with your actual report data)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session Summary',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      report.reportDetails,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Row(
                  //   children: [
                  //     Icon(Icons.assessment, size: 16.w, color: primaryColor),
                  //     SizedBox(width: 4.w),
                  //     Text(
                  //       'Progress: Moderate',
                  //       style: TextStyle(
                  //         fontSize: 14.sp,
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Action Buttons
            // Row(
            //   children: [
            //     Expanded(
            //       child: _buildActionButton(
            //         text: 'View Full Report',
            //         icon: Icons.description,
            //         onPressed: onViewDetails,
            //       ),
            //     ),
            //     SizedBox(width: 10.w),
            //     Expanded(
            //       child: _buildActionButton(
            //         text: 'Share',
            //         icon: Icons.share,
            //         onPressed: onShare,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18.w, color: primaryColor),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
