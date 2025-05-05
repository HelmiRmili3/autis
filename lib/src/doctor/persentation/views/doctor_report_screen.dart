import 'package:autis/injection_container.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/params/report/create_report_params.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/strings.dart';
import '../../../common/blocs/report_bloc/report_bloc.dart';
import '../../../common/blocs/report_bloc/report_event.dart';
import '../../../common/blocs/report_bloc/report_state.dart';
import '../../../common/widgets/report_card.dart';
import '../widgets/costom_appbar.dart';

class DoctorReportScreen extends StatefulWidget {
  final PatientEntity patient;
  const DoctorReportScreen({
    super.key,
    required this.patient,
  });

  @override
  State<DoctorReportScreen> createState() => _DoctorReportScreenState();
}

class _DoctorReportScreenState extends State<DoctorReportScreen> {
  late DoctorEntity currentDoctor;
  @override
  void initState() {
    sl<ReportBloc>().add(GetReportsForDoctor(widget.patient.uid));
    _loadPatientFromStorage();
    super.initState();
  }

  Future<void> _loadPatientFromStorage() async {
    final user = await sl<UserProfileStorage>().getUserProfile();

    if (user != null) {
      setState(() {
        currentDoctor = DoctorEntity(
          uid: user.uid,
          email: user.email,
          firstname: user.firstname,
          lastname: user.lastname,
          avatarUrl: user.avatarUrl,
          gender: user.gender,
          phone: user.phone ?? '',
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
          licenseNumber: "KJZSEJK12",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: Strings.reports),
      floatingActionButton: _showPopUpForm(),
      body: HomeBg(
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            // Handle different states
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReportsLoaded) {
              if (state.reports.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.read_more,
                        size: 60.sp,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "No Reports Found",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          "We couldn't find any available reports right now. "
                          "Check back later or try refreshing the page.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: state.reports.length,
                  itemBuilder: (context, index) {
                    return ReportCard(
                      report: state.reports[index],
                      onShare: () {},
                      onViewDetails: () {},
                    );
                  },
                ),
              );
            }

            if (state is ReportInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReportFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }

            return const Center(child: Text('No reports available'));
          },
        ),
      ),
    );
  }
  // Add this to your _DoctorReportScreenState class

  FloatingActionButton _showPopUpForm() {
    return FloatingActionButton(
      onPressed: () => _showAddReportDialog(context),
      child: const Icon(Icons.add),
    );
  }

  void _showAddReportDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final reportDetailsController = TextEditingController();
    final attachmentUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Report'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    controller: reportDetailsController,
                    decoration: const InputDecoration(
                      labelText: 'Report Details',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter report details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: attachmentUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Attachment URL (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // // Dispatch event to create report
                  sl<ReportBloc>().add(CreateReport(
                    CreateReportParams(
                      widget.patient.uid,
                      currentDoctor.uid,
                      widget.patient,
                      currentDoctor,
                      reportDetailsController.text,
                      attachmentUrlController.text.isNotEmpty
                          ? attachmentUrlController.text
                          : null,
                    ),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
