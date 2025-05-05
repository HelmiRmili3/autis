import 'package:autis/injection_container.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../common/view/container_screen.dart';
import '../../../common/widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: 'Profile',
      imagePath: 'assets/images/homebg.png',
      leadingicon: Icons.arrow_back_ios_new_rounded,
      onLeadingPress: () => sl<NavigationService>().goBack(),
      children: const [
        ProfileCard(),
      ],
    );
  }
}
