import 'package:autis/src/common/entitys/report_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback? onViewDetails;
  final VoidCallback? onShare;
  final VoidCallback? onEdit;

  final Color primaryColor = const Color(0xFF0076BE);
  final Color accentColor = const Color(0xFF00F1F8);

  const ReportCard({
    super.key,
    required this.report,
    this.onViewDetails,
    this.onShare,
    this.onEdit,
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
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'share' && onShare != null) {
                      onShare!();
                    } else if (value == 'view' && onViewDetails != null) {
                      onViewDetails!();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    if (onEdit != null)
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20.w),
                            SizedBox(width: 8.w),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    if (onViewDetails != null)
                      PopupMenuItem<String>(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 20.w),
                            SizedBox(width: 8.w),
                            Text('View Details'),
                          ],
                        ),
                      ),
                    if (onShare != null)
                      PopupMenuItem<String>(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 20.w),
                            SizedBox(width: 8.w),
                            Text('Share'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Appointment Details
            _buildDetailRow(icon: Icons.calendar_today, text: formattedDate),
            SizedBox(height: 8.h),
            _buildDetailRow(icon: Icons.access_time, text: formattedTime),

            SizedBox(height: 16.h),

            // Report Summary
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
                ],
              ),
            ),
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
