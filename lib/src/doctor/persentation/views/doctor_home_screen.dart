import 'package:autis/core/utils/strings.dart';
import 'package:autis/src/common/blocs/auth_bloc/auth_bloc.dart';
import 'package:autis/src/common/blocs/auth_bloc/auth_state.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:autis/src/doctor/persentation/widgets/gass_app_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/floating_bottom_bar.dart';
import '../widgets/patient_invite_list.dart';
import '../widgets/patient_list.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const PatientList(),
    const InviteList(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBar = const [
    BottomNavigationBarItem(
      icon: Icon(EneftyIcons.home_bold),
      label: Strings.patients,
    ),
    BottomNavigationBarItem(
      icon: Icon(EneftyIcons.call_bold),
      label: Strings.invites,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: CustomGlassAppBar(
              title: state.user.firstname,
              avatarUrl: state.user.avatarUrl,
            ),
            body: Stack(
              children: [
                HomeBg(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: _pages,
                  ),
                ),
                Positioned(
                  left: 1,
                  right: 1,
                  bottom: 10,
                  child: FloatingBottomBar(
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    items: _bottomNavigationBar,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
