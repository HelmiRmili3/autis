import 'package:autis/core/routes/route_names.dart';
import 'package:autis/core/services/navigation_service.dart';
import 'package:autis/core/utils/extentions.dart';
import 'package:autis/src/common/blocs/doctor_bloc/doctor_bloc.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_bloc.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_event.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_state.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autis/src/common/blocs/auth_bloc/auth_bloc.dart';

import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';
import '../../../common/blocs/auth_bloc/auth_event.dart';
import '../../../common/blocs/auth_bloc/auth_state.dart';
import '../../../common/blocs/doctor_bloc/doctor_event.dart';
import '../../../common/entitys/user_entity.dart';
import '../../../doctor/persentation/widgets/costom_appbar.dart';
import '../../../doctor/persentation/widgets/detail_row.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  @override
  void initState() {
    sl<PatientBloc>().add(GetPatient());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          sl<NavigationService>().replaceNamed(RoutesNames.login);
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          sl<DoctorBloc>().add(FetchDoctor(doctorId: user.uid));
          return _buildProfileScreen(context, user);
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Please login to view profile'),
            ),
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
        title: Strings.profile.capitalizeFirst(),
        avatarUrl: user.avatarUrl,
        active: false,
      ),
      body: HomeBg(
        child: BlocBuilder<PatientBloc, PatientState>(
          builder: (context, state) {
            if (state is PatientLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is PatientFailure) {
              return Center(
                child: Text(state.error),
              );
            }
            if (state is PatientLoaded) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 120.h, horizontal: 16.w),
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
                          backgroundImage:
                              NetworkImage(state.patient.avatarUrl),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.patient.firstname} ${state.patient.lastname}',
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
                                  DetailRow(
                                    icon: Icons.email,
                                    text: state.patient.email,
                                  ),
                                  const SizedBox(height: 8),
                                  if (user.phone != null)
                                    DetailRow(
                                      icon: Icons.phone,
                                      text: state.patient.phone!,
                                    ),
                                  const SizedBox(height: 8),
                                  if (user.location != null)
                                    DetailRow(
                                      icon: Icons.location_on,
                                      text: state.patient.location!,
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
                                sl<NavigationService>().pushNamed(
                                  RoutesNames.pateintEditProfileScreen,
                                  extra: user,
                                );
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
                                Strings.logout.capitalizeFirst(),
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
              );
            }

            return const SizedBox.shrink();
          },
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
