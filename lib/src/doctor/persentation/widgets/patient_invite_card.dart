import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/enums/invite_enum.dart';
import '../../../common/entitys/invite_entity.dart';

class InviteCard extends StatelessWidget {
  final InviteEntity invite;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const InviteCard({
    super.key,
    required this.invite,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Match ProfileCard color
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          // Avatar
          Padding(
            padding: EdgeInsets.all(8.w),
            child: CircleAvatar(
              radius: 30.r,
              backgroundImage: NetworkImage(invite.patient.avatarUrl),
            ),
          ),

          // Patient Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${invite.patient.firstname} ${invite.patient.lastname}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  invite.patient.email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons or Status Icon
          if (invite.status == InviteStatus.pending)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.greenAccent),
                  onPressed: onAccept,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.redAccent),
                  onPressed: onReject,
                ),
              ],
            )
          else
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Icon(
                invite.status == InviteStatus.accepted
                    ? Icons.check_circle
                    : Icons.cancel,
                color: invite.status == InviteStatus.accepted
                    ? Colors.greenAccent
                    : Colors.redAccent,
                size: 24.sp,
              ),
            ),
        ],
      ),
    );
  }

  // Color _getStatusColor(InviteStatus status) {
  //   switch (status) {
  //     case InviteStatus.pending:
  //       return Colors.orangeAccent;
  //     case InviteStatus.accepted:
  //       return Colors.greenAccent;
  //     case InviteStatus.rejected:
  //       return Colors.redAccent;
  //     default:
  //       return Colors.white;
  //   }
  // }
}
