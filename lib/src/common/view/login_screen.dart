import 'package:autis/core/params/authentication/login_user_params.dart';
import 'package:autis/core/services/navigation_service.dart';
import 'package:autis/src/common/widgets/custom_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/enums/notification_enum.dart';
import '../../../injection_container.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../widgets/costom_password_filed.dart';
import '../widgets/custom_button.dart';
import 'container_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isFirstTime = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   super.initState();
  //   if (isFirstTime) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       sl<NotificationService>().showCustomManualDismissNotification(
  //         context: context,
  //         message: "You have to create an account to track your kids progress",
  //         type: NotificationType.warning,
  //       );
  //     });
  //   }
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Navigate to home screen after successful login
          sl<NavigationService>().goToNamed(
            RoutesNames.home,
            extra: state.user.role,
          );
          // if(state.user.)
        } else if (state is AuthenticationFailure) {
          // Show error message
          sl<NotificationService>().showCustomManualDismissNotification(
            context: context,
            message: state.error,
            type: NotificationType.error,
          );
        }
      },
      child: ContainerAuth(
        children: [
          Container(
            height: 500.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              top: 150.h,
              left: 20.w,
              right: 20.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.h),
                    CustomFormTextFiled(
                      controller: _emailController,
                      lableText: "Email",
                      hintText: "example@example.com",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomPasswordField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        sl<NotificationService>()
                            .showAutoDismissibleNotification(
                          message:
                              "Please contact support to reset your password",
                          type: NotificationType.warning,
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF0076BE),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomButton(
                          title: 'Login',
                          icon: Icons.person,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthLoggedIn(
                                      Loginuserprams(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    ),
                                  );
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10.w),
                          height: 1.h,
                          width: 100.w,
                          color: const Color(0xFF0076BE),
                        ),
                        Text(
                          'Or',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF0076BE),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          height: 1.h,
                          width: 100.w,
                          color: const Color(0xFF0076BE),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      title: 'Login with Google',
                      icon: Icons.g_mobiledata,
                      onPressed: () {
                        // TODO: Implement Google Sign-In
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF0076BE),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).go('/register');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.red,
                              fontFamily: 'Poppins',
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
          Positioned(
            top: 130.h,
            left: 60.w,
            right: 60.w,
            child: Container(
              height: 60.h,
              width: 200.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00F1F8),
                    Color(0xFF0076BE),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Center(
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
