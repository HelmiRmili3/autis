import 'package:autis/injection_container.dart';
import 'package:autis/src/common/blocs/chat_bloc/chat_bloc.dart';
import 'package:autis/src/common/blocs/game_bloc/game_bloc.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_bloc.dart';
import 'package:autis/src/common/blocs/report_bloc/report_bloc.dart';
import 'package:provider/provider.dart';

import 'src/common/blocs/appointement_bloc/appointement_bloc.dart';
import 'src/common/blocs/auth_bloc/auth_bloc.dart';
import 'src/common/blocs/doctor_bloc/doctor_bloc.dart';
import 'src/common/blocs/invite_bloc/invite_bloc.dart';

List<Provider> providers = [
  // Add your providers here
  Provider<AuthBloc>(create: (_) => sl<AuthBloc>()),
  Provider<InviteBloc>(create: (_) => sl<InviteBloc>()),
  Provider<AppointmentBloc>(create: (_) => sl<AppointmentBloc>()),
  Provider<DoctorBloc>(create: (_) => sl<DoctorBloc>()),
  Provider<ReportBloc>(create: (_) => sl<ReportBloc>()),
  Provider<PatientBloc>(create: (_) => sl<PatientBloc>()),
  Provider<GameBloc>(create: (_) => sl<GameBloc>()),
  Provider<ChatBloc>(create: (_) => sl<ChatBloc>()),
];
