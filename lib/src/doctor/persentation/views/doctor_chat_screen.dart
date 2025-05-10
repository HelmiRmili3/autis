import 'package:autis/src/common/blocs/chat_bloc/chat_bloc.dart';
import 'package:autis/src/common/blocs/chat_bloc/chat_event.dart';
import 'package:autis/src/common/blocs/chat_bloc/chat_state.dart';
import 'package:autis/src/common/containers/home_background.dart';
import 'package:autis/src/common/entitys/message_entity.dart';
import 'package:autis/src/doctor/domain/entities/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../injection_container.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../widgets/costom_appbar.dart';

class DoctorChatScreen extends StatefulWidget {
  final PatientEntity patient;

  const DoctorChatScreen({
    super.key,
    required this.patient,
  });

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  late DoctorEntity? currentUser;
  bool isLoadingUser = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    sl<ChatBloc>().add(GetChat(widget.patient.uid));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await sl<UserProfileStorage>().getUserProfile();
      setState(() {
        currentUser = user != null
            ? DoctorEntity(
                uid: user.uid,
                email: user.email,
                firstname: user.firstname,
                lastname: user.lastname,
                avatarUrl: user.avatarUrl,
                dateOfBirth: user.dateOfBirth,
                gender: user.gender,
                createdAt: user.createdAt,
                updatedAt: user.updatedAt,
                phone: user.phone,
                licenseNumber: '',
              )
            : null;
        isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: "Chats",
        active: false,
      ),
      body: HomeBg(
        child: isLoadingUser
            ? const Center(child: CircularProgressIndicator())
            : BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (currentUser == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatFailure) {
                    return Center(child: Text(state.error));
                  }

                  if (state is ChatLoaded) {
                    if (state.chat == null) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<ChatBloc>()
                                .add(CreateConversation(widget.patient.uid));
                          },
                          child: const Text('Start Conversation'),
                        ),
                      );
                    }

                    final messages = state.chat!.messages.toList()
                      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
                    final currentUserId = currentUser!.uid;

                    return Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        bottom: 16.h,
                        left: 16.w,
                        right: 16.w,
                      ),
                      child: Column(
                        children: [
                          // Messages List
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              reverse: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isMe = message.senderId == currentUserId;

                                return MessageBubble(
                                  message: message,
                                  isMe: isMe,
                                  doctorAvatar: currentUser!.avatarUrl,
                                  patientAvatar: widget.patient.avatarUrl,
                                );
                              },
                            ),
                          ),

                          // Message Input
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: "Type your message...",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 12.h,
                                      ),
                                    ),
                                    onSubmitted: (text) {
                                      if (text.trim().isNotEmpty) {
                                        context
                                            .read<ChatBloc>()
                                            .add(SendMessage(
                                              state.chat!.chatId,
                                              text,
                                            ));
                                        _messageController.clear();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: IconButton(
                                    icon: Icon(Icons.send,
                                        color: Colors.white, size: 20.sp),
                                    onPressed: () {
                                      final text =
                                          _messageController.text.trim();
                                      if (text.isNotEmpty) {
                                        context
                                            .read<ChatBloc>()
                                            .add(SendMessage(
                                              state.chat!.chatId,
                                              text,
                                            ));
                                        _messageController.clear();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;
  final String? doctorAvatar;
  final String? patientAvatar;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.doctorAvatar,
    this.patientAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe)
              CircleAvatar(
                backgroundImage: NetworkImage(patientAvatar ?? ''),
                radius: 14.r,
              ),
            SizedBox(width: 8.w),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color:
                      isMe ? Theme.of(context).primaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 16.r : 4.r),
                    topRight: Radius.circular(isMe ? 4.r : 16.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isMe ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isMe)
              CircleAvatar(
                backgroundImage: NetworkImage(doctorAvatar ?? ''),
                radius: 14.r,
              ),
          ],
        ),
      ),
    );
  }
}
