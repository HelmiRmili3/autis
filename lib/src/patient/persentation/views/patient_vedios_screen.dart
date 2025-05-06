import 'package:autis/src/common/blocs/patient_bloc/patient_bloc.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_event.dart';
import 'package:autis/src/common/blocs/patient_bloc/patient_state.dart';
import 'package:autis/src/doctor/persentation/widgets/costom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';
import '../../../common/entitys/video.dart';
import '../../domain/entities/patient_entity.dart';

class PatientVideosScreen extends StatefulWidget {
  const PatientVideosScreen({
    super.key,
  });

  @override
  State<PatientVideosScreen> createState() => _DoctorVideosScreenState();
}

class _DoctorVideosScreenState extends State<PatientVideosScreen> {
  PatientEntity? currentUser;
  bool _isLoading = true;

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int? _currentlyPlayingIndex;
  bool _isLoadingVideo = false;
  late String id;
  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      if (mounted) {
        setState(() {
          currentUser = user != null
              ? PatientEntity(
                  uid: user.uid,
                  email: user.email,
                  firstname: user.firstname,
                  lastname: user.lastname,
                  avatarUrl: user.avatarUrl,
                  gender: user.gender,
                  createdAt: user.createdAt,
                  updatedAt: user.updatedAt,
                  phone: user.phone,
                )
              : null;
          _isLoading = false;
        });

        // Add this after setting the state
        if (currentUser != null) {
          sl<PatientBloc>().add(GetAllVedios(currentUser!.uid));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initVideoPlayer(String videoUrl, int index) async {
    if (_currentlyPlayingIndex == index) return;

    setState(() {
      _isLoadingVideo = true;
    });

    // Dispose previous controllers
    await _disposeVideoControllers();

    try {
      // ignore: deprecated_member_use
      _videoPlayerController = VideoPlayerController.network(videoUrl);
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        placeholder: Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).primaryColor,
          handleColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey[300]!,
          bufferedColor: Colors.grey[200]!,
        ),
        allowedScreenSleep: false,
        showOptions: true,
        showControlsOnInitialize: false,
      );

      setState(() {
        _currentlyPlayingIndex = index;
        _isLoadingVideo = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingVideo = false;
        _currentlyPlayingIndex = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load video: ${e.toString()}')));
    }
  }

  Future<void> _disposeVideoControllers() async {
    await _chewieController?.pause();
    _chewieController?.dispose();
    await _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
  }

  Future<void> _pauseCurrentVideo() async {
    if (_chewieController?.isPlaying ?? false) {
      await _chewieController?.pause();
    }
    setState(() {
      _currentlyPlayingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Strings.educationalvideos),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : BlocBuilder<PatientBloc, PatientState>(
              builder: (context, state) {
                if (state is PatientLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is VedioFailure) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                if (state is VediosLoaded) {
                  final List<Video> videos = state.vedios;
                  return ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final isPlaying = _currentlyPlayingIndex == index;

                      return Card(
                        margin: EdgeInsets.only(bottom: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () async {
                            if (isPlaying) {
                              await _pauseCurrentVideo();
                            } else {
                              await _initVideoPlayer(video.videoUrl, index);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Video player or thumbnail
                              if (isPlaying &&
                                  _chewieController != null &&
                                  !_isLoadingVideo)
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12.r)),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child:
                                        Chewie(controller: _chewieController!),
                                  ),
                                )
                              else
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12.r)),
                                      child: Image.network(
                                        video.thumbnail,
                                        width: double.infinity,
                                        height: 180.h,
                                        fit: BoxFit.fill,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            height: 180.h,
                                            width: double.infinity,
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          height: 180.h,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.broken_image,
                                              size: 50),
                                        ),
                                      ),
                                    ),
                                    if (_isLoadingVideo &&
                                        _currentlyPlayingIndex == index)
                                      const Center(
                                          child: CircularProgressIndicator())
                                    else
                                      Positioned.fill(
                                        child: Center(
                                          child: Icon(
                                            Icons.play_circle_fill,
                                            size: 50.sp,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 8.h,
                                      right: 8.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          video.duration,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              // Video info
                              Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video.title,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        SizedBox(width: 16.w),
                                        Icon(Iconsax.calendar, size: 16.sp),
                                        SizedBox(width: 4.w),
                                        Text(
                                          video.uploadDate,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}
