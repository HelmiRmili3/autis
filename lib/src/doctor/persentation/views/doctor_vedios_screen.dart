import 'dart:io';

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

import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/utils/file_picker.dart';
import '../../../../core/utils/strings.dart';
import '../../../../injection_container.dart';
import '../../../common/entitys/video.dart';

class DoctorVideosScreen extends StatefulWidget {
  final String patientId;
  const DoctorVideosScreen({super.key, required this.patientId});

  @override
  State<DoctorVideosScreen> createState() => _DoctorVideosScreenState();
}

class _DoctorVideosScreenState extends State<DoctorVideosScreen> {
  // Video player controllers
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int? _currentlyPlayingIndex;
  bool _isLoadingVideo = false;
  @override
  void initState() {
    sl<PatientBloc>().add(GetAllVedios(widget.patientId));
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  File? _videoPath;

  Future<void> _uploadVideo(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => Form(
        key: _formKey,
        child: AlertDialog(
          title: const Text('Upload New Video'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Video Title'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                  onChanged: (value) => _title = value,
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _pickVideo,
                  child: const Text('Select Video'),
                ),
                if (_videoPath != null)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      'Video selected',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _videoPath != null) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Please select a video and enter a title')),
                  );
                }
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      await _performUpload();
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await FilePicker().pickVideo();

    if (pickedFile != null) {
      setState(() {
        _videoPath = pickedFile;
      });
    }
  }

  Future<void> _performUpload() async {
    if (_videoPath == null) return;

    try {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final response =
          await sl<CloudinaryRestService>().uploadVideo(_videoPath!);

      sl<PatientBloc>().add(UploadVedio(
          widget.patientId, _title, '', response['playback_url'], '0:00'));

      debugPrint(response.toString());

      navigator.pop(); // Close loading dialog

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Video uploaded successfully')),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _videoPath = null;
        _title = '';
      });
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
      appBar: const CustomAppBar(
        title: Strings.educationalvideos,
        active: false,
      ),
      body: BlocBuilder<PatientBloc, PatientState>(
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
                              child: Chewie(controller: _chewieController!),
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
                                    if (loadingProgress == null) return child;
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
                                  errorBuilder: (context, error, stackTrace) =>
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
                                const Center(child: CircularProgressIndicator())
                              else
                                Positioned.fill(
                                  child: Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      size: 50.sp,
                                      color: Colors.white.withOpacity(0.8),
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
                                    borderRadius: BorderRadius.circular(4.r),
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
                        Row(
                          children: [
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
                            GestureDetector(
                              onTap: () {
                                sl<PatientBloc>().add(DeleteVedio(video.id));
                              },
                              child: const Text("Delete"),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadVideo(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
