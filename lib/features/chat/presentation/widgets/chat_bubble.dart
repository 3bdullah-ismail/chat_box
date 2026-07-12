import 'package:chat_app/core/constants/color_manager.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        // بيحاذي المحتوى بالكامل يمين أو شمال بناءً على الراسل
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // صندوق الرسالة
          Container(
            padding: const EdgeInsets.only(
              top: 12,
              left: 20,
              right: 40.75,
              bottom: 12,
            ),
            constraints: const BoxConstraints(maxWidth: 297.50),
            decoration: BoxDecoration(
              // لون أسود لرسالتك وأبيض لرسالة الطرف الآخر
              color: isMe ? ColorManager.black : ColorManager.white,
              border: Border.all(
                color: isMe ? Colors.transparent : ColorManager.borderGray,
                width: 1,
              ),
              // الحواف دائرية بانتظام من كل الجهات زي الصورة
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.04),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                // كتابة بيضاء على الخلفية السوداء، وسودة على الخلفية البيضاء
                color: isMe ? ColorManager.white : ColorManager.nearBlack,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),

          const SizedBox(height: 4), // مسافة صغيرة بين الصندوق والوقت
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: ColorManager.neutralGray,
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // لو الرسالة بتاعتي، بنظهر علامتي الصح الزرقاء جنب الوقت
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    size: 14,
                    color: ColorManager.blue, // اللون الأزرق لعلامة الصح
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
