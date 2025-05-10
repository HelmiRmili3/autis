import 'dart:io';

import 'package:autis/core/routes/route_names.dart';
import 'package:autis/core/services/navigation_service.dart';
import 'package:autis/core/utils/enums/role_enum.dart';
import 'package:autis/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:autis/core/utils/extentions.dart';
import 'package:autis/src/common/blocs/doctor_bloc/doctor_bloc.dart';
import 'package:autis/src/common/blocs/doctor_bloc/doctor_event.dart';
import 'package:autis/src/common/blocs/doctor_bloc/doctor_state.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:autis/src/common/entitys/user_entity.dart';

import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/utils/strings.dart';
import '../../domain/entities/update_doctor_params.dart';
import '../widgets/costom_appbar.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  final UserEntity user;

  const DoctorEditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<DoctorEditProfileScreen> createState() =>
      _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _avatarController;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstname);
    _lastNameController = TextEditingController(text: widget.user.lastname);
    _phoneController = TextEditingController(text: widget.user.phone);
    _avatarController = TextEditingController(text: widget.user.avatarUrl);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      final response =
          await sl<CloudinaryRestService>().uploadImage(_selectedImage!);
      _avatarController.text = response['secure_url'];

      debugPrint("image url : ${response.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            title: Strings.editProfile.capitalizeFirst(),
            avatarUrl: widget.user.avatarUrl,
            active: false,
          ),
          body: HomeBg(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 120.h, horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfilePicture(),
                    SizedBox(height: 24.h),
                    _buildEditForm(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _selectedImage != null
              ? FileImage(_selectedImage!)
              : NetworkImage(widget.user.avatarUrl) as ImageProvider,
        ),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildEditField(
            label: 'First Name',
            controller: _firstNameController,
            icon: Icons.person,
          ),
          SizedBox(height: 12.h),
          _buildEditField(
            label: 'Last Name',
            controller: _lastNameController,
            icon: Icons.person,
          ),
          SizedBox(height: 12.h),
          _buildEditField(
            label: 'Phone',
            controller: _phoneController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12.h),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontFamily: "Mulish",
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.1),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00F1F8),
            Color(0xFF0076BE),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ElevatedButton(
        onPressed: () {
          final params = UpdateDoctorParams(
            doctorId: widget.user.uid,
            firstname: _firstNameController.text,
            lastname: _lastNameController.text,
            phone: _phoneController.text,
            avatarUrl: _avatarController.text,
          );

          sl<DoctorBloc>().add(UpdateDoctor(doctor: params));
          sl<NavigationService>().replaceNamed(
            RoutesNames.home,
            extra: Role.doctor,
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Save Changes',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "Mulish",
          ),
        ),
      ),
    );
  }
}
