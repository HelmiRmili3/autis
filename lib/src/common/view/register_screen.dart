import 'package:autis/core/params/authentication/create_user_params.dart';
import 'package:autis/core/utils/extentions.dart';
import 'package:autis/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/utils/enums/gender_enum.dart';
import '../../../core/utils/enums/role_enum.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../widgets/costom_password_filed.dart';
import '../widgets/custom_button.dart';
import 'container_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Gender? _selectedGender;
  Role? _selectedRole;
  final Color primaryColor = const Color(0xFF0076BE);
  final Color accentColor = const Color(0xFF00F1F8);

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          // Navigate to home or login screen after successful registration
          sl<NavigationService>().goToNamed(RoutesNames.login);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ContainerAuth(
        children: [
          Container(
            height: 600.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              top: 100.h,
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
                left: 10,
                right: 10,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 80.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                      ),
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
                    DropdownButtonFormField<Gender>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 15.h,
                        ),
                      ),
                      items: Gender.values.map((gender) {
                        return DropdownMenuItem<Gender>(
                          value: gender,
                          child: Text(
                            gender.displayName,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (Gender? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select your gender' : null,
                    ),
                    SizedBox(height: 20.h),
                    DropdownButtonFormField<Role>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        prefixIcon: const Icon(Icons.work, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 15.h,
                        ),
                      ),
                      items: Role.values
                          .where((role) => role != Role.admin)
                          .map((role) {
                        return DropdownMenuItem<Role>(
                          value: role,
                          child: Text(
                            role.displayName.capitalizeFirst(),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (Role? value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select your role' : null,
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
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomButton(
                          title: 'Register',
                          icon: Icons.person,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Create user object and dispatch RegisterRequested event
                              final user = CreateUserParams(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                phone: "24355565",
                                password: _passwordController.text,
                                gender: _selectedGender!,
                                role: _selectedRole!,
                              );

                              context
                                  .read<AuthBloc>()
                                  .add(RegisterRequested(user));
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have an account?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF0076BE),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            sl<NavigationService>()
                                .goToNamed(RoutesNames.login);
                          },
                          child: Text(
                            'Sign In',
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
            top: 80.h,
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
                  'Create Account',
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
