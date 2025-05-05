import 'package:autis/core/services/notification_service.dart';
import 'package:autis/core/utils/enums/notification_enum.dart';
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/params/invite/create_invite_params.dart';
import '../../../injection_container.dart';
import '../../patient/domain/entities/patient_entity.dart';
import '../blocs/invite_bloc/invite_bloc.dart';
import '../blocs/invite_bloc/invite_event.dart';
import '../blocs/invite_bloc/invite_state.dart';
import 'doctor_list.dart';
import 'invitation_card_.dart';

class DoctorSelectionCard extends StatefulWidget {
  final List<DoctorEntity> doctors;
  final PatientEntity user;
  const DoctorSelectionCard({
    super.key,
    required this.doctors,
    required this.user,
  });

  @override
  State<DoctorSelectionCard> createState() => _DoctorSelectionCardState();
}

class _DoctorSelectionCardState extends State<DoctorSelectionCard> {
  int? _selectedDoctorIndex;
  bool _hasInvitation = false;
  String _invitationStatus = 'Pending';
  DoctorEntity? _invitedDoctor;

  @override
  void initState() {
    super.initState();
    // Check invite status when widget initializes
    context
        .read<InviteBloc>()
        .add(CheckInviteStatus(patientId: widget.user.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InviteBloc, InviteState>(
      listener: (context, state) {
        if (state is InviteFailure) {
          sl<NotificationService>().showCustomManualDismissNotification(
            context: context,
            message: "You need to select doctor to send Invitation",
            type: NotificationType.warning,
          );
        } else if (state is InvitePending) {
          setState(() {
            _hasInvitation = true;
            _invitationStatus = 'Pending';
            _invitedDoctor = widget.doctors.firstWhere(
              (doctor) => doctor.uid == state.invite.doctorId,
              orElse: () => widget.doctors.first,
            );
          });
        } else if (state is InviteAccepted) {
          setState(() {
            _hasInvitation = true;
            _invitationStatus = 'Accepted';
            _invitedDoctor = widget.doctors.firstWhere(
              (doctor) => doctor.uid == state.invite.doctorId,
              orElse: () => widget.doctors.first,
            );
          });
        } else if (state is InviteRejected) {
          setState(() {
            _hasInvitation = false;
            _invitationStatus = 'Rejected';
          });
        } else if (state is InviteLoaded) {
          setState(() {
            _hasInvitation = true;
            _invitationStatus = 'Pending';
          });
        }
      },
      child: Column(
        children: [
          if (_hasInvitation && _invitedDoctor != null)
            InvitedDoctorCard(
              doctor: _invitedDoctor!,
              invitationStatus: _invitationStatus,
            ),
          if (!_hasInvitation || _invitedDoctor == null) ...[
            DoctorListWidget(
              doctors: widget.doctors,
              selectedDoctorIndex: _selectedDoctorIndex,
              hasInvitation: _hasInvitation,
              onDoctorSelected: (index) {
                setState(() {
                  _selectedDoctorIndex = index;
                });
              },
            ),
            if (_selectedDoctorIndex != null) _buildSendInvitationButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildSendInvitationButton() {
    return BlocBuilder<InviteBloc, InviteState>(
      builder: (context, state) {
        if (state is InviteLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 5,
              ),
              onPressed: () {
                if (_selectedDoctorIndex != null) {
                  final selectedDoctor = widget.doctors[_selectedDoctorIndex!];
                  context.read<InviteBloc>().add(
                        SendInvite(
                          CreateInviteParams(
                            patient: widget.user,
                            patientId: widget.user.uid,
                            doctor: selectedDoctor,
                            doctorId: selectedDoctor.uid,
                          ),
                        ),
                      );
                  setState(() {
                    _invitedDoctor = selectedDoctor;
                  });
                }
              },
              child: Text(
                'Send Invitation',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0076BE),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
