import 'package:autis/core/services/navigation_service.dart';
import 'package:autis/src/common/blocs/appointement_bloc/appointement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/params/appointment/create_appointment_params.dart';
import '../../../../injection_container.dart';
import '../../../doctor/domain/entities/doctor_entity.dart';
import '../../domain/entities/patient_entity.dart';
import '../../../common/blocs/appointement_bloc/appointement_bloc.dart';
import '../../../common/blocs/appointement_bloc/appointement_event.dart';

class AppointmentForm extends StatefulWidget {
  final PatientEntity patient;
  final String formTitle;
  final String submitButtonText;
  final GlobalKey<FormState>? formKey;
  final DoctorEntity? initialDoctor;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final String? initialLocation;
  final VoidCallback? onCancel;
  // final VoidCallback? onSubmit;

  const AppointmentForm({
    super.key,
    required this.patient,
    this.formTitle = 'New Appointment',
    this.submitButtonText = 'CREATE',
    this.formKey,
    this.initialDoctor,
    this.initialDate,
    this.initialTime,
    this.initialLocation,
    this.onCancel,
    // this.onSubmit,
  });

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _doctorController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late DoctorEntity? _selectedDoctor;
  late DateTime? _selectedDate;
  late TimeOfDay? _selectedTime;
  late String _selectedLocation;

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _doctorController =
        TextEditingController(text: widget.initialDoctor!.email);
    _selectedDoctor = widget.initialDoctor;
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
    _selectedLocation = widget.initialLocation ?? '';

    if (_selectedDate != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    if (_selectedTime != null) {
      _timeController.text = _selectedTime!.format(context);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Stack(
          children: [
            Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 650.h,
                  width: 350.w,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.r,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20.h),
                          TextFormField(
                            controller: _doctorController,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              prefixIcon:
                                  Icon(Icons.calendar_today, size: 20.sp),
                            ),
                            readOnly: true,
                          ),
                          SizedBox(height: 15.h),
                          TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              prefixIcon:
                                  Icon(Icons.calendar_today, size: 20.sp),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  _selectedDate = date;
                                  _dateController.text =
                                      DateFormat('yyyy-MM-dd').format(date);
                                });
                              }
                            },
                            validator: (value) =>
                                value!.isEmpty ? 'Please select a date' : null,
                          ),
                          SizedBox(height: 15.h),
                          TextFormField(
                            controller: _timeController,
                            decoration: InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              prefixIcon: Icon(Icons.access_time, size: 20.sp),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime ?? TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() {
                                  _selectedTime = time;
                                  _timeController.text = time.format(context);
                                });
                              }
                            },
                            validator: (value) =>
                                value!.isEmpty ? 'Please select a time' : null,
                          ),
                          SizedBox(height: 15.h),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Location',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              prefixIcon: Icon(Icons.location_on, size: 20.sp),
                            ),
                            controller:
                                TextEditingController(text: _selectedLocation),
                            onChanged: (value) => _selectedLocation = value,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a location'
                                : null,
                          ),
                          SizedBox(height: 25.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF0076BE),
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: Text(
                              widget.submitButtonText,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
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
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.formTitle,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50.h,
              right: 0.w,
              child: IconButton(
                icon: Container(
                  width: 35.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
                onPressed: widget.onCancel,
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final appointment = CreateAppointmentParams(
        doctorId: _selectedDoctor!.uid,
        patientId: widget.patient.uid,
        doctor: _selectedDoctor!,
        patient: widget.patient,
        appointmentDate: DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
        location: _selectedLocation,
      );
      sl<AppointmentBloc>().add(CreatedAppointement(appointment));
      sl<AppointmentBloc>().add(GetPatientAppointements());
      sl<NavigationService>().goBack();
    }
  }
}
