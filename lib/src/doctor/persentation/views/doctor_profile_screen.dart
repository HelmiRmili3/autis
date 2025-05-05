import 'package:autis/core/routes/route_names.dart';
import 'package:autis/core/services/navigation_service.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autis/src/common/blocs/auth_bloc/auth_bloc.dart';

import '../../../../injection_container.dart';
import '../../../common/blocs/auth_bloc/auth_event.dart';
import '../../../common/blocs/auth_bloc/auth_state.dart';
import '../../../common/entitys/user_entity.dart';
import '../widgets/costom_appbar.dart';
import '../widgets/detail_row.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // Navigate to login screen when logged out
          sl<NavigationService>().replaceNamed(RoutesNames.login);
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return _buildProfileScreen(context, user);
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Please login to view profile')),
          );
        }
      },
    );
  }

  Scaffold _buildProfileScreen(BuildContext context, UserEntity user) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Profile",
        avatarUrl: user.avatarUrl,
      ),
      body: HomeBg(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 120.h, horizontal: 16.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(bottom: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstname} ${user.lastname}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Medical Professional',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
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
                            DetailRow(
                              icon: Icons.email,
                              text: user.email,
                            ),
                            const SizedBox(height: 8),
                            if (user.phone != null)
                              DetailRow(
                                icon: Icons.phone,
                                text: user.phone!,
                              ),
                            const SizedBox(height: 8),
                            if (user.location != null)
                              DetailRow(
                                icon: Icons.location_on,
                                text: user.location!,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Edit Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to edit profile screen
                          Navigator.pushNamed(context, '/edit-profile');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Mulish",
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 2,
                      color: Colors.white,
                      indent: 8,
                      endIndent: 8,
                    ),
                    // Logout Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showLogoutDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Mulish",
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.w,
            ),
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Confirm Logout",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00F1F8),
                          Color(0xFF0076BE),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(AuthLoggedOut());
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
