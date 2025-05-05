import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../doctor/domain/entities/doctor_entity.dart';
import '../../../common/blocs/doctor_bloc/doctor_bloc.dart';
import '../../../common/blocs/doctor_bloc/doctor_event.dart';
import '../../../common/blocs/doctor_bloc/doctor_state.dart';

class DoctorDropdown extends StatefulWidget {
  final DoctorEntity? selectedDoctor;
  final ValueChanged<DoctorEntity?> onChanged;

  const DoctorDropdown({
    super.key,
    required this.selectedDoctor,
    required this.onChanged,
  });

  @override
  State<DoctorDropdown> createState() => _DoctorDropdownState();
}

class _DoctorDropdownState extends State<DoctorDropdown> {
  @override
  void initState() {
    super.initState();
    // Fetch verified doctors on widget init
    context.read<DoctorBloc>().add(FetchVerifiedDoctors());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoading) {
          return const CircularProgressIndicator();
        } else if (state is DoctorsLoaded) {
          final doctors = state.doctors;

          return DropdownButtonFormField<DoctorEntity>(
            decoration: InputDecoration(
              labelText: 'Select Doctor',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.person, size: 20),
            ),
            value: widget.selectedDoctor,
            items: doctors.map((doctor) {
              return DropdownMenuItem<DoctorEntity>(
                value: doctor,
                child: Text(
                  'Dr. ${doctor.firstname} ${doctor.lastname}',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: widget.onChanged,
            validator: (value) =>
                value == null ? 'Please select a doctor' : null,
          );
        } else if (state is DoctorError) {
          return Text(state.error, style: const TextStyle(color: Colors.red));
        } else {
          return const SizedBox.shrink(); // Empty if initial or unknown
        }
      },
    );
  }
}
