import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:autis/src/common/blocs/game_bloc/game_bloc.dart';
import 'package:autis/src/common/blocs/game_bloc/game_event.dart';
import 'package:autis/src/common/blocs/game_bloc/game_state.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:autis/src/patient/domain/entities/patient_entity.dart';
import 'package:autis/src/patient/domain/entities/game_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';
import '../widgets/costom_appbar.dart';
import '../widgets/doctor_game_card.dart';

class DoctorGameScreen extends StatefulWidget {
  final PatientEntity patient;
  const DoctorGameScreen({
    super.key,
    required this.patient,
  });

  @override
  State<DoctorGameScreen> createState() => _DoctorGameScreenState();
}

class _DoctorGameScreenState extends State<DoctorGameScreen> {
  @override
  void initState() {
    sl<GameBloc>().add(GetGames(widget.patient.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: Strings.games),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return HomeBg(
            child: _buildBodyContent(context, state),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadGameJson(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, GameState state) {
    if (state is GameLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GamesLoaded) {
      return _buildGamesList(state.games);
    } else if (state is GameFailure) {
      return Center(child: Text('Error: ${state.error}'));
    }
    // Initial state
    return const Center(child: Text("No games available"));
  }

  Widget _buildGamesList(List<GameEntity> games) {
    if (games.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_esports_outlined,
              size: 60.sp,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              "No Games Found",
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
                "We couldn't find any available games right now. "
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 100.h),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        padding: EdgeInsets.all(16.w),
        childAspectRatio: 0.6,
        children: games
            .map((game) => DoctorGameCard(
                  id: game.id,
                  game: game,
                  patientId: widget.patient.uid,
                  title: game.name,
                  levels: '${game.levels.length} levels',
                  onPressed: () => _openGameDetails(context, game),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _uploadGameJson(BuildContext context) async {
    final gameBloc = context.read<GameBloc>();

    try {
      // 1. Pick JSON file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null) return;

      // 2. Read and parse file
      final file = File(result.files.first.path!);
      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString);

      // 3. Validate and convert
      final game = GameEntity.fromJson(jsonData);

      // 4. Dispatch event
      gameBloc.add(UploadGame(
        game,
        widget.patient.uid,
      ));
    } on FormatException catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorSnackbar(context, 'Invalid JSON format: ${e.message}');
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorSnackbar(context, 'Failed to upload game: ${e.toString()}');
    }
  }

  void _openGameDetails(BuildContext context, GameEntity game) {
    context.read<GameBloc>().add(OpenGame(game));
    // Navigate to game details screen
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
