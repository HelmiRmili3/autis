import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../injection_container.dart';
import '../../../common/blocs/auth_bloc/auth_bloc.dart';
import '../../../common/blocs/auth_bloc/auth_event.dart';
import '../../../common/blocs/auth_bloc/auth_state.dart';

class DoctorNotAuthorizedScreen extends StatelessWidget {
  const DoctorNotAuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            sl<NavigationService>().replaceNamed(RoutesNames.login);
          }
        },
        builder: (context, state) {
          if (state is Authenticated) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: 80,
                      color: Colors.orange.withOpacity(0.7),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Account Pending Verification",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your doctor account is currently being reviewed by our admin team. "
                      "This process typically takes 1-2 business days.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text("Go back"),
                      onPressed: () {
                        sl<AuthBloc>().add(AuthLoggedOut());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }

          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
