import 'package:autis/core/utils/strings.dart';
import 'package:autis/src/common/blocs/report_bloc/report_event.dart';
import 'package:autis/src/common/view/container_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../../injection_container.dart';
import '../../../common/blocs/report_bloc/report_bloc.dart';
import '../../../common/blocs/report_bloc/report_state.dart';
import '../../../common/widgets/report_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    sl<ReportBloc>().add(GetReportsForPatient());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: Strings.reports,
      imagePath: 'assets/images/homebg.png',
      leadingicon: Icons.arrow_back_ios_new_rounded,
      onLeadingPress: () => sl<NavigationService>().goBack(),
      children: [
        BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReportsLoaded) {
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
        )
      ],
    );
  }
}
