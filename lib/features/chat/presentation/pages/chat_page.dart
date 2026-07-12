import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorManager.black,
          ),
          onPressed: () => context.pop(),
        ),
        backgroundColor: ColorManager.white,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAvatar(title: "a"),
            SizedBox(width: 8),
            Text('Abdullah', style: TextStyle(color: ColorManager.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: ColorManager.black, size: 36.sp),
            onPressed: () {},
          ),
          8.horizontalSpace,
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorManager.lightBlue, ColorManager.white],
          ),
        ),
        child: Column(
          children: [
            /// Messages
            Expanded(
              child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(16),
                children: const [
                  ChatBubble(text: 'Hello', isMe: true, time: '2:00'),
                  ChatBubble(
                    text: 'Hi, how are you?',
                    isMe: false,
                    time: '5:30',
                  ),
                  ChatBubble(text: 'I am fine', isMe: true, time: '8:55'),
                ],
              ),
            ),

            /// Input field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Send message',
                  suffixIcon: const Icon(Icons.send, color: ColorManager.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ColorManager.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
